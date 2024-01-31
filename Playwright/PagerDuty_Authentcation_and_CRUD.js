/**
 * This check will check the functionality of the PagerDuty API
 * It will create, get, update and delete an escalation policy
 * The PagerDuty API documentation is available here: https://developer.pagerduty.com/api-reference/
 */

import { test, expect } from "@playwright/test"

const baseUrl = "https://api.pagerduty.com"

const headers = {
  Authorization: `Token token=${process.env.PAGERDUTY_API_KEY}`,
  "Content-Type": "application/json",
  "From": process.env.PAGERDUTY_EMAIL,
  "Accept": "application/vnd.pagerduty+json;version=2"
}

test("CRUD Escalation Policy in PagerDuty API", async ({ request }) => {
  let policyId;

  /**
   * Create an escalation policy
   */
  await test.step("POST /escalation_policies", async () => {
    const response = await request.post(`${baseUrl}/escalation_policies`, {
      data: JSON.stringify({
        escalation_policy: {
          type: "escalation_policy",
          name: "New Escalation Policy",
          escalation_rules: [
            {
              escalation_delay_in_minutes: 30,
              targets: [
                {
                  id: process.env.PAGERDUTY_USER_ID,
                  type: "user_reference"
                }
              ]
            }
          ],
          num_loops: 2,
          teams: [],
          description: "This is a new escalation policy"
        }
      }),
      headers,
    })
    const data = await response.json();
    policyId = data.escalation_policy.id;
    expect(response).toBeOK()
  })

  /**
   * Read the escalation policy
   */
  await test.step("GET /escalation_policies/{id}", async () => {
    const response = await request.get(`${baseUrl}/escalation_policies/${policyId}`, { headers })
    expect(response).toBeOK()
  })

  /**
   * Update the escalation policy
   */
  await test.step("PUT /escalation_policies/{id}", async () => {
    const response = await request.put(`${baseUrl}/escalation_policies/${policyId}`, {
      data: JSON.stringify({
        escalation_policy: {
          type: "escalation_policy",
          name: "Updated Escalation Policy",
          description: "This is an updated escalation policy"
        }
      }),
      headers,
    })
    expect(response).toBeOK()
  })

  /**
   * Delete the escalation policy
   */
  await test.step("DELETE /escalation_policies/{id}", async () => {
    const response = await request.delete(`${baseUrl}/escalation_policies/${policyId}`, { headers })
    expect(response).toBeOK()
  })
})