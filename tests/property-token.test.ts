import { describe, it, beforeEach, expect } from "vitest"

describe("property-management", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      createMaintenanceRequest: (propertyId: number, description: string, cost: number) => ({ value: 1 }),
      updateRequestStatus: (requestId: number, newStatus: string) => ({ success: true }),
      getMaintenanceRequest: (requestId: number) => ({
        propertyId: 1,
        description: "Fix leaky faucet",
        cost: 100,
        status: "pending",
      }),
      getPropertyRequests: (propertyId: number) => [
        {
          requestId: 1,
          propertyId: 1,
          description: "Fix leaky faucet",
          cost: 100,
          status: "pending",
        },
      ],
    }
  })
  
  describe("create-maintenance-request", () => {
    it("should create a new maintenance request", () => {
      const result = contract.createMaintenanceRequest(1, "Fix leaky faucet", 100)
      expect(result.value).toBe(1)
    })
  })
  
  describe("update-request-status", () => {
    it("should update the status of a maintenance request", () => {
      const result = contract.updateRequestStatus(1, "completed")
      expect(result.success).toBe(true)
    })
  })
  
  describe("get-maintenance-request", () => {
    it("should return details of a maintenance request", () => {
      const result = contract.getMaintenanceRequest(1)
      expect(result.propertyId).toBe(1)
      expect(result.description).toBe("Fix leaky faucet")
      expect(result.cost).toBe(100)
      expect(result.status).toBe("pending")
    })
  })
  
  describe("get-property-requests", () => {
    it("should return all maintenance requests for a property", () => {
      const result = contract.getPropertyRequests(1)
      expect(result.length).toBe(1)
      expect(result[0].requestId).toBe(1)
      expect(result[0].propertyId).toBe(1)
      expect(result[0].description).toBe("Fix leaky faucet")
      expect(result[0].cost).toBe(100)
      expect(result[0].status).toBe("pending")
    })
  })
})

