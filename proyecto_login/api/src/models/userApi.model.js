/**
*Author:   DIEGO CASALLAS
*Date:     01/01/2026
*Description: Model for API user operations and authentication.
**/
import { connect } from '../config/db/connect.js';
import { encryptPassword, comparePassword } from '../library/appBcrypt.js';
import jwt from "jsonwebtoken";

const isNonEmptyString = (value) =>
  typeof value === "string" && value.trim().length > 0;

const hasValue = (value) => {
  if (value === undefined || value === null) {
    return false;
  }

  if (typeof value === "string") {
    return value.trim().length > 0;
  }

  return true;
};

const parsePositiveInt = (value) => {
  const parsedValue = Number.parseInt(value, 10);
  return Number.isInteger(parsedValue) && parsedValue > 0 ? parsedValue : null;
};

const getBogotaTimestamp = () =>
  new Date()
    .toLocaleString("sv-SE", { timeZone: "America/Bogota" })
    .replace(" ", " ");

const isInactiveStatus = (status) => {
  if (status === 0 || status === false || status === "0") {
    return true;
  }

  const normalizedStatus = String(status).trim().toLowerCase();
  return ["inactive", "inactivo", "disabled", "bloqueado"].includes(normalizedStatus);
};

class UserApiModel {
  constructor(id, user, password, status, role) {
    this.id = id;
    this.user = user;
    this.password = password;
    this.status = status;
    this.role = role;
  }

  async showApiUser(req, res) {
    try {
      const sqlQuery = "SELECT Api_user_id, Api_user, Api_status, Api_role, Created_at, Updated_at FROM api_users";
      const [result] = await connect.query(sqlQuery);

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error fetching users",
        details: error.message,
      });
    }
  }

  async showApiUserId(req, res) {
    const userId = parsePositiveInt(req.params.id);

    if (!userId) {
      return res.status(400).json({
        success: false,
        error: "Invalid user id",
      });
    }

    try {
      const sqlQuery = "SELECT Api_user_id, Api_user, Api_status, Api_role, Created_at, Updated_at FROM api_users WHERE Api_user_id = ?";
      const [result] = await connect.query(sqlQuery, [userId]);

      if (result.length === 0) {
        return res.status(404).json({
          success: false,
          error: "User not found",
        });
      }

      return res.status(200).json({
        success: true,
        data: result[0],
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error fetching user",
        details: error.message,
      });
    }
  }

  async addApiUser(req, res) {
    const { user, password, status, role } = req.body;
    const normalizedUser = typeof user === "string" ? user.trim() : "";
    const normalizedPassword = typeof password === "string" ? password.trim() : "";

    if (!isNonEmptyString(normalizedUser) || !isNonEmptyString(normalizedPassword) || !hasValue(status) || !hasValue(role)) {
      return res.status(400).json({
        success: false,
        error: "user, password, status and role are required",
      });
    }

    if (normalizedUser.length < 3) {
      return res.status(400).json({
        success: false,
        error: "user must contain at least 3 characters",
      });
    }

    if (normalizedPassword.length < 6) {
      return res.status(400).json({
        success: false,
        error: "password must contain at least 6 characters",
      });
    }

    try {
      const [existingUser] = await connect.query(
        "SELECT Api_user_id FROM api_users WHERE Api_user = ?",
        [normalizedUser]
      );

      if (existingUser.length > 0) {
        return res.status(409).json({
          success: false,
          error: "User already exists",
        });
      }

      const hashedPassword = await encryptPassword(normalizedPassword);
      const sqlQuery = "INSERT INTO api_users(Api_user, Api_password, Api_status, Api_role) VALUES (?, ?, ?, ?)";
      const [result] = await connect.query(sqlQuery, [normalizedUser, hashedPassword, status, role]);

      return res.status(201).json({
        success: true,
        message: "User created successfully",
        data: {
          id: result.insertId,
          user: normalizedUser,
          status,
          role,
        },
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error adding user",
        details: error.message,
      });
    }
  }

  async updateApiUser(req, res) {
    const userId = parsePositiveInt(req.params.id);
    const { user, password, role, status } = req.body;
    const normalizedUser = typeof user === "string" ? user.trim() : "";
    const normalizedPassword = typeof password === "string" ? password.trim() : "";

    if (!userId) {
      return res.status(400).json({
        success: false,
        error: "Invalid user id",
      });
    }

    if (!isNonEmptyString(normalizedUser) || !isNonEmptyString(normalizedPassword) || !hasValue(status) || !hasValue(role)) {
      return res.status(400).json({
        success: false,
        error: "user, password, status and role are required",
      });
    }

    if (normalizedUser.length < 3) {
      return res.status(400).json({
        success: false,
        error: "user must contain at least 3 characters",
      });
    }

    if (normalizedPassword.length < 6) {
      return res.status(400).json({
        success: false,
        error: "password must contain at least 6 characters",
      });
    }

    try {
      const [currentUser] = await connect.query(
        "SELECT Api_user_id FROM api_users WHERE Api_user_id = ?",
        [userId]
      );

      if (currentUser.length === 0) {
        return res.status(404).json({
          success: false,
          error: "User not found",
        });
      }

      const [duplicatedUser] = await connect.query(
        "SELECT Api_user_id FROM api_users WHERE Api_user = ? AND Api_user_id <> ?",
        [normalizedUser, userId]
      );

      if (duplicatedUser.length > 0) {
        return res.status(409).json({
          success: false,
          error: "User already exists",
        });
      }

      const hashedPassword = await encryptPassword(normalizedPassword);
      const updatedAt = getBogotaTimestamp();
      const sqlQuery = "UPDATE api_users SET Api_user = ?, Api_password = ?, Api_role = ?, Api_status = ?, Updated_at = ? WHERE Api_user_id = ?";
      const [result] = await connect.query(sqlQuery, [normalizedUser, hashedPassword, role, status, updatedAt, userId]);

      return res.status(200).json({
        success: true,
        message: "User updated successfully",
        data: {
          id: userId,
          user: normalizedUser,
          status,
          role,
          updated_at: updatedAt,
        },
        updated: result.affectedRows,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error updating user",
        details: error.message,
      });
    }
  }

  async deleteApiUser(req, res) {
    const userId = parsePositiveInt(req.params.id);

    if (!userId) {
      return res.status(400).json({
        success: false,
        error: "Invalid user id",
      });
    }

    try {
      const sqlQuery = "DELETE FROM api_users WHERE Api_user_id = ?";
      const [result] = await connect.query(sqlQuery, [userId]);

      if (result.affectedRows === 0) {
        return res.status(404).json({
          success: false,
          error: "User not found",
        });
      }

      return res.status(200).json({
        success: true,
        message: "User deleted successfully",
        deleted: result.affectedRows,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error deleting user",
        details: error.message,
      });
    }
  }

  async loginApiUser(req, res) {
    const { api_user, api_password } = req.body;
    const normalizedUser = typeof api_user === "string" ? api_user.trim() : "";
    const normalizedPassword = typeof api_password === "string" ? api_password.trim() : "";

    if (!isNonEmptyString(normalizedUser) || !isNonEmptyString(normalizedPassword)) {
      return res.status(400).json({
        success: false,
        error: "api_user and api_password are required",
      });
    }

    if (normalizedUser.length < 3) {
      return res.status(400).json({
        success: false,
        error: "api_user must contain at least 3 characters",
      });
    }

    if (normalizedPassword.length < 6) {
      return res.status(400).json({
        success: false,
        error: "api_password must contain at least 6 characters",
      });
    }

    if (!process.env.JWT_SECRET) {
      return res.status(500).json({
        success: false,
        error: "JWT secret is not configured",
      });
    }

    try {
      const sqlQuery = "SELECT * FROM api_users WHERE Api_user = ?";
      const [result] = await connect.query(sqlQuery, [normalizedUser]);

      if (result.length === 0) {
        return res.status(401).json({
          success: false,
          error: "Invalid credentials",
        });
      }

      const user = result[0];
      const validPassword = await comparePassword(normalizedPassword, user.Api_password);

      if (!validPassword) {
        return res.status(401).json({
          success: false,
          error: "Invalid credentials",
        });
      }

      if (isInactiveStatus(user.Api_status)) {
        return res.status(403).json({
          success: false,
          error: "User is inactive",
        });
      }

      const token = jwt.sign(
        {
          id: user.Api_user_id,
          role: user.Api_role,
          status: user.Api_status,
        },
        process.env.JWT_SECRET,
        {
          expiresIn: process.env.JWT_EXPIRES_IN || "1h",
        }
      );

      return res.status(200).json({
        success: true,
        token,
        message: "Login successful",
        user: {
          id: user.Api_user_id,
          username: user.Api_user,
          role: user.Api_role,
          status: user.Api_status,
        },
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error during login",
        details: error.message,
      });
    }
  }
}

export default UserApiModel;
