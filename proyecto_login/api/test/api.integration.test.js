import test, { after, before, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { once } from 'node:events';

import app from '../src/app/app.js';
import { connect } from '../src/config/db/connect.js';
import { encryptPassword } from '../src/library/appBcrypt.js';

let server;
let baseUrl;
let originalQuery;

before(async () => {
  originalQuery = connect.query;
  server = app.listen(0);
  await once(server, 'listening');
  const address = server.address();
  baseUrl = `http://127.0.0.1:${address.port}/api_v1`;
});

after(async () => {
  connect.query = originalQuery;

  if (server) {
    await new Promise((resolve, reject) => {
      server.close((error) => {
        if (error) {
          reject(error);
          return;
        }

        resolve();
      });
    });
  }
});

beforeEach(() => {
  connect.query = async () => {
    throw new Error('Unexpected query in test');
  };
});

test('login and list user statuses with a valid token', async () => {
  const hashedPassword = await encryptPassword('secret123');

  connect.query = async (sql, params) => {
    if (sql.includes('SELECT * FROM api_users WHERE Api_user = ?')) {
      assert.deepEqual(params, ['admin']);

      return [[{
        Api_user_id: 1,
        Api_user: 'admin',
        Api_password: hashedPassword,
        Api_role: 'ADMIN',
        Api_status: 'Active',
      }]];
    }

    if (sql.includes('FROM user_status') && sql.includes('ORDER BY User_status_id ASC')) {
      return [[
        {
          User_status_id: 1,
          User_status_name: 'Active',
          User_status_description: 'Active',
          create_at: '2024-05-18 00:44:01',
          update_at: null,
        },
        {
          User_status_id: 2,
          User_status_name: 'Inactive',
          User_status_description: 'Inactive',
          create_at: '2024-05-18 00:44:01',
          update_at: null,
        },
      ]];
    }

    throw new Error(`Unexpected query: ${sql}`);
  };

  const loginResponse = await fetch(`${baseUrl}/apiUserLogin`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      api_user: 'admin',
      api_password: 'secret123',
    }),
  });

  assert.equal(loginResponse.status, 200);
  const loginJson = await loginResponse.json();
  assert.equal(loginJson.success, true);
  assert.ok(loginJson.token);

  const statusResponse = await fetch(`${baseUrl}/userStatus`, {
    headers: {
      Authorization: `Bearer ${loginJson.token}`,
    },
  });

  assert.equal(statusResponse.status, 200);
  const statusJson = await statusResponse.json();
  assert.equal(statusJson.success, true);
  assert.equal(statusJson.data.length, 2);
  assert.equal(statusJson.data[0].User_status_name, 'Active');
});

test('creating a user status validates required fields', async () => {
  const hashedPassword = await encryptPassword('secret123');

  connect.query = async (sql, params) => {
    if (sql.includes('SELECT * FROM api_users WHERE Api_user = ?')) {
      assert.deepEqual(params, ['admin']);

      return [[{
        Api_user_id: 1,
        Api_user: 'admin',
        Api_password: hashedPassword,
        Api_role: 'ADMIN',
        Api_status: 'Active',
      }]];
    }

    throw new Error(`Unexpected query: ${sql}`);
  };

  const loginResponse = await fetch(`${baseUrl}/apiUserLogin`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      api_user: 'admin',
      api_password: 'secret123',
    }),
  });

  const loginJson = await loginResponse.json();

  const createResponse = await fetch(`${baseUrl}/userStatus`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${loginJson.token}`,
    },
    body: JSON.stringify({
      name: '',
      description: '',
    }),
  });

  assert.equal(createResponse.status, 400);
  const createJson = await createResponse.json();
  assert.equal(createJson.success, false);
  assert.equal(createJson.error, 'name and description are required');
});

test('creating a new user status returns success and the new record', async () => {
  const hashedPassword = await encryptPassword('secret123');

  connect.query = async (sql, params) => {
    if (sql.includes('SELECT * FROM api_users WHERE Api_user = ?')) {
      assert.deepEqual(params, ['admin']);

      return [[{
        Api_user_id: 1,
        Api_user: 'admin',
        Api_password: hashedPassword,
        Api_role: 'ADMIN',
        Api_status: 'Active',
      }]];
    }

    if (sql.includes('SELECT User_status_id FROM user_status WHERE User_status_name = ?')) {
      assert.deepEqual(params, ['Blocked']);
      return [[]];
    }

    if (sql.includes('INSERT INTO user_status')) {
      assert.deepEqual(params, ['Blocked', 'This is Blocked']);
      return [{ insertId: 5, affectedRows: 1 }];
    }

    throw new Error(`Unexpected query: ${sql}`);
  };

  const loginResponse = await fetch(`${baseUrl}/apiUserLogin`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      api_user: 'admin',
      api_password: 'secret123',
    }),
  });

  const loginJson = await loginResponse.json();

  const createResponse = await fetch(`${baseUrl}/userStatus`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${loginJson.token}`,
    },
    body: JSON.stringify({
      name: 'Blocked',
      description: 'This is Blocked',
    }),
  });

  assert.equal(createResponse.status, 201);
  const createJson = await createResponse.json();
  assert.equal(createJson.success, true);
  assert.equal(createJson.data.name, 'Blocked');
  assert.equal(createJson.data.description, 'This is Blocked');
});
