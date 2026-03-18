/**
*Author:   DIEGO CASALLAS
*Date:     01/01/2026
*Description: Controller for API user operations and login endpoints.
**/
import UserApiModel from '../models/userApi.model.js';
import { connect } from '../config/db/connect.js';
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const getBearerToken = (authorizationHeader = "") => {
  if (typeof authorizationHeader !== "string" || !authorizationHeader.startsWith("Bearer ")) {
    return null;
  }

  const token = authorizationHeader.slice(7).trim();
  return token || null;
};

const parsePositiveInt = (value) => {
  const parsedValue = Number.parseInt(value, 10);
  return Number.isInteger(parsedValue) && parsedValue > 0 ? parsedValue : null;
};

const getBogotaTimestamp = () =>
  new Date().toLocaleString("sv-SE", { timeZone: "America/Bogota" });

export const showApiUser = async (req, res) => {
  try {
    const userApiModel = new UserApiModel();
    await userApiModel.showApiUser(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error fetching users",
      details: error.message,
    });
  }
};

export const showApiUserId = async (req, res) => {
  try {
    const userApiModel = new UserApiModel();
    await userApiModel.showApiUserId(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error fetching user",
      details: error.message,
    });
  }
};

export const addApiUser = async (req, res) => {
  try {
    const userApiModel = new UserApiModel();
    await userApiModel.addApiUser(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error adding user",
      details: error.message,
    });
  }
};

export const updateApiUser = async (req, res) => {
  try {
    const userApiModel = new UserApiModel();
    await userApiModel.updateApiUser(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error updating user",
      details: error.message,
    });
  }
};

export const deleteApiUser = async (req, res) => {
  try {
    const userApiModel = new UserApiModel();
    await userApiModel.deleteApiUser(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error deleting user",
      details: error.message,
    });
  }
};

export const loginApiUser = async (req, res) => {
  try {
    const userApiModel = new UserApiModel();
    await userApiModel.loginApiUser(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error logging in user",
      details: error.message,
    });
  }
};

export const verifyTokenLogin = (req, res) => {
  const token =
    req.body.token ||
    req.query.token ||
    getBearerToken(req.headers.authorization);

  if (!process.env.JWT_SECRET) {
    return res.status(500).json({
      success: false,
      error: "JWT secret is not configured",
    });
  }

  if (!token) {
    return res.status(401).json({
      success: false,
      error: "Token is required",
    });
  }

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified;

    return res.status(200).json({
      success: true,
      message: "Token is valid",
      user: verified,
    });
  } catch (error) {
    const isExpiredToken = error.name === "TokenExpiredError";

    return res.status(401).json({
      success: false,
      error: isExpiredToken ? "Token expired" : "Invalid token",
    });
  }
};

export const registerUserStatusLogin = async (req, res) => {
  if (!process.env.JWT_SECRET) {
    return res.status(500).json({
      success: false,
      error: "JWT secret is not configured",
    });
  }

  const token = getBearerToken(req.headers.authorization);
  if (!token) {
    return res.status(401).json({
      success: false,
      error: "Authorization token is required in Bearer format",
    });
  }

  const statusId = parsePositiveInt(req.body.user_status_id);
  if (!statusId) {
    return res.status(400).json({
      success: false,
      error: "user_status_id must be a positive integer",
    });
  }

  let decodedToken;
  try {
    decodedToken = jwt.verify(token, process.env.JWT_SECRET);
  } catch (error) {
    const isExpiredToken = error.name === "TokenExpiredError";

    return res.status(401).json({
      success: false,
      error: isExpiredToken ? "Token expired" : "Invalid token",
    });
  }

  const userId = parsePositiveInt(decodedToken.id);
  if (!userId) {
    return res.status(401).json({
      success: false,
      error: "Invalid token payload",
    });
  }

  try {
    const sqlQuery = `
      INSERT INTO user_status (User_status_id, User_id, Created_at)
      VALUES (?, ?, ?)
    `;

    const timestamp = getBogotaTimestamp();
    await connect.query(sqlQuery, [statusId, userId, timestamp]);

    return res.status(201).json({
      success: true,
      message: "User status registered successfully",
      data: {
        userId,
        statusId,
        timestamp,
      },
    });
  } catch (error) {
    if (error.code === "ER_NO_REFERENCED_ROW_2") {
      return res.status(422).json({
        success: false,
        error: "Referenced user or status does not exist",
      });
    }

    return res.status(500).json({
      success: false,
      error: "Error registering user status",
      details: error.message,
    });
  }
};
