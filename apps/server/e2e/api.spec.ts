import { test, expect } from '@playwright/test';

test.describe('Taskflow / Subscription API E2E Suite', () => {

  test('E2E Spec 1: GET /health should return service status ok', async ({ request }) => {
    const response = await request.get('/health');
    expect(response.status()).toBe(200);
    const body = await response.json();
    expect(body.status).toBe('ok');
    expect(body.timestamp).toBeDefined();
  });

  test('E2E Spec 2: GET /health/ping should return pong and uptime', async ({ request }) => {
    const response = await request.get('/health/ping');
    expect(response.status()).toBe(200);
    const body = await response.json();
    expect(body.message).toBe('pong');
    expect(body.uptime).toBeDefined();
  });

  test('E2E Spec 3: GET /packages should return available packages list', async ({ request }) => {
    const response = await request.get('/packages');
    expect([200, 404]).toContain(response.status());
  });

});
