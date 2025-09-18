class JobTypesMockResponse {
  static const Map<String,dynamic> okResponse = {
    "data": [
      {
        "id": 1,
        "name": "Installation",
        "trade_id": 0,
        "insurance_claim": false
      },
      {
        "id": 2,
        "name": "Service / Maintenance / Warranty",
        "trade_id": 0,
        "insurance_claim": false
      },
      {
        "id": 3,
        "name": "Repair",
        "trade_id": 0,
        "insurance_claim": false
      },
      {
        "id": 4,
        "name": "Insurance Claim",
        "trade_id": 0,
        "insurance_claim": true
      },
      {
        "id": 5,
        "name": "Inspection",
        "trade_id": 0,
        "insurance_claim": false
      }
    ],
    "status": 200
  };
}