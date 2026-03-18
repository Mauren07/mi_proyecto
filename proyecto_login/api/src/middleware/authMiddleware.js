/**
*Author:   DIEGO CASALLAS
*Date:     01/01/2026
*Description: Middleware to verify JWT tokens in protected routes.
**/

import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const getBearerToken = (authorizationHeader = "") => {
  if (typeof authorizationHeader !== "string") {
    return null;
  }

  if (!authorizationHeader.startsWith("Bearer ")) {
    return null;
  }

  const token = authorizationHeader.slice(7).trim();
  return token || null;
};

export const verifyToken = (req, res, next) => {
  if (!process.env.JWT_SECRET) {
    return res.status(500).json({
      success: false,
      error: "JWT secret is not configured",
    });
  }

  const token = getBearerToken(req.header("Authorization"));

  if (!token) {
    return res.status(401).json({
      success: false,
      error: "Authorization token is required in Bearer format",
    });
  }

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified;
    next();
  } catch (error) {
    const isExpiredToken = error.name === "TokenExpiredError";

    return res.status(401).json({
      success: false,
      error: isExpiredToken ? "Token expired" : "Invalid token",
    });
  }
};
