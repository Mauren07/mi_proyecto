/**
*Author:   DIEGO CASALLAS
*Date:     01/01/2026
*Description: Model for user status catalog operations.
**/
import { connect } from '../config/db/connect.js';

const isNonEmptyString = (value) =>
  typeof value === "string" && value.trim().length > 0;

const parsePositiveInt = (value) => {
  const parsedValue = Number.parseInt(value, 10);
  return Number.isInteger(parsedValue) && parsedValue > 0 ? parsedValue : null;
};

const getBogotaTimestamp = () =>
  new Date().toLocaleString("sv-SE", { timeZone: "America/Bogota" });

class UserStatusModel {
  constructor(id, name, description) {
    this.id = id;
    this.name = name;
    this.description = description;
  }

  async showUserStatus(req, res) {
    try {
      const sqlQuery = `
        SELECT
          User_status_id,
          User_status_name,
          User_status_description,
          create_at,
          update_at
        FROM user_status
        ORDER BY User_status_id ASC
      `;

      const [result] = await connect.query(sqlQuery);

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error fetching user statuses",
        details: error.message,
      });
    }
  }

  async showUserStatusId(req, res) {
    const statusId = parsePositiveInt(req.params.id);

    if (!statusId) {
      return res.status(400).json({
        success: false,
        error: "Invalid user status id",
      });
    }

    try {
      const sqlQuery = `
        SELECT
          User_status_id,
          User_status_name,
          User_status_description,
          create_at,
          update_at
        FROM user_status
        WHERE User_status_id = ?
      `;

      const [result] = await connect.query(sqlQuery, [statusId]);

      if (result.length === 0) {
        return res.status(404).json({
          success: false,
          error: "User status not found",
        });
      }

      return res.status(200).json({
        success: true,
        data: result[0],
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error fetching user status",
        details: error.message,
      });
    }
  }

  async addUserStatus(req, res) {
    const { name, description } = req.body;
    const normalizedName = typeof name === "string" ? name.trim() : "";
    const normalizedDescription =
      typeof description === "string" ? description.trim() : "";

    if (!isNonEmptyString(normalizedName) || !isNonEmptyString(normalizedDescription)) {
      return res.status(400).json({
        success: false,
        error: "name and description are required",
      });
    }

    if (normalizedName.length < 3) {
      return res.status(400).json({
        success: false,
        error: "name must contain at least 3 characters",
      });
    }

    if (normalizedDescription.length < 3) {
      return res.status(400).json({
        success: false,
        error: "description must contain at least 3 characters",
      });
    }

    try {
      const [existingStatus] = await connect.query(
        "SELECT User_status_id FROM user_status WHERE User_status_name = ?",
        [normalizedName]
      );

      if (existingStatus.length > 0) {
        return res.status(409).json({
          success: false,
          error: "User status already exists",
        });
      }

      const sqlQuery = `
        INSERT INTO user_status (User_status_name, User_status_description)
        VALUES (?, ?)
      `;
      const [result] = await connect.query(sqlQuery, [
        normalizedName,
        normalizedDescription,
      ]);

      return res.status(201).json({
        success: true,
        message: "User status created successfully",
        data: {
          id: result.insertId,
          name: normalizedName,
          description: normalizedDescription,
        },
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error adding user status",
        details: error.message,
      });
    }
  }

  async updateUserStatus(req, res) {
    const statusId = parsePositiveInt(req.params.id);
    const { name, description } = req.body;
    const normalizedName = typeof name === "string" ? name.trim() : "";
    const normalizedDescription =
      typeof description === "string" ? description.trim() : "";

    if (!statusId) {
      return res.status(400).json({
        success: false,
        error: "Invalid user status id",
      });
    }

    if (!isNonEmptyString(normalizedName) || !isNonEmptyString(normalizedDescription)) {
      return res.status(400).json({
        success: false,
        error: "name and description are required",
      });
    }

    if (normalizedName.length < 3) {
      return res.status(400).json({
        success: false,
        error: "name must contain at least 3 characters",
      });
    }

    if (normalizedDescription.length < 3) {
      return res.status(400).json({
        success: false,
        error: "description must contain at least 3 characters",
      });
    }

    try {
      const [currentStatus] = await connect.query(
        "SELECT User_status_id FROM user_status WHERE User_status_id = ?",
        [statusId]
      );

      if (currentStatus.length === 0) {
        return res.status(404).json({
          success: false,
          error: "User status not found",
        });
      }

      const [duplicatedStatus] = await connect.query(
        "SELECT User_status_id FROM user_status WHERE User_status_name = ? AND User_status_id <> ?",
        [normalizedName, statusId]
      );

      if (duplicatedStatus.length > 0) {
        return res.status(409).json({
          success: false,
          error: "User status already exists",
        });
      }

      const updateAt = getBogotaTimestamp();
      const sqlQuery = `
        UPDATE user_status
        SET User_status_name = ?, User_status_description = ?, update_at = ?
        WHERE User_status_id = ?
      `;

      const [result] = await connect.query(sqlQuery, [
        normalizedName,
        normalizedDescription,
        updateAt,
        statusId,
      ]);

      return res.status(200).json({
        success: true,
        message: "User status updated successfully",
        data: {
          id: statusId,
          name: normalizedName,
          description: normalizedDescription,
          update_at: updateAt,
        },
        updated: result.affectedRows,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error updating user status",
        details: error.message,
      });
    }
  }

  async deleteUserStatus(req, res) {
    const statusId = parsePositiveInt(req.params.id);

    if (!statusId) {
      return res.status(400).json({
        success: false,
        error: "Invalid user status id",
      });
    }

    try {
      const sqlQuery = "DELETE FROM user_status WHERE User_status_id = ?";
      const [result] = await connect.query(sqlQuery, [statusId]);

      if (result.affectedRows === 0) {
        return res.status(404).json({
          success: false,
          error: "User status not found",
        });
      }

      return res.status(200).json({
        success: true,
        message: "User status deleted successfully",
        deleted: result.affectedRows,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: "Error deleting user status",
        details: error.message,
      });
    }
  }
}

export default UserStatusModel;
