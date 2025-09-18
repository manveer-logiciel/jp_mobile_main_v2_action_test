class MockedOperationTable {
  static Map<String, dynamic> tableData = {
    "head": [
      {
        "id": "",
        "tds": [
          {
            "text": "Heading 1",
            "width": 246.417,
            "style": {
              "width": "247px"
            },
            "id": ""
          },
          {
            "text": "Heading 2",
            "width": 246.417,
            "style": {
              "width": "247px"
            },
            "id": ""
          },
          {
            "text": "Heading 3",
            "width": 239.452,
            "style": {
              "width": "240px"
            },
            "id": ""
          }
        ]
      }
    ],
    "body": [
      {
        "id": "",
        "tds": [
          {
            "text": "\$10",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 0,
            "col": 0
          },
          {
            "text": "12",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 0,
            "col": 1
          },
          {
            "text": "14",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 0,
            "col": 2
          }
        ],
        "options": <String, dynamic>{}
      },
      {
        "id": "",
        "tds": [
          {
            "text": "21",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 1,
            "col": 0
          },
          {
            "text": "kkk",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 1,
            "col": 1
          },
          {
            "text": "12",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 1,
            "col": 2
          }
        ],
        "options": <String, dynamic>{}
      },
      {
        "id": "",
        "tds": [
          {
            "text": "33",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 2,
            "col": 0
          },
          {
            "text": "22",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 2,
            "col": 1
          },
          {
            "text": "44",
            "dropdown": <String, dynamic>{},
            "cssClass": "cell-with-dropdown",
            "isNumber": "false",
            "refDb": "",
            "style": <String, dynamic>{},
            "id": "",
            "spanId": "",
            "ddId": "",
            "row": 2,
            "col": 2
          }
        ],
        "options": <String, dynamic>{}
      }
    ],
    "foot": [
      {
        "tds": [
          {
            "text": "\$64.00",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$64.00",
              "focus": false,
              "dropdown": <String, dynamic>{},
              "operation": "sum",
              "field": 0
            }
          },
          {
            "text": "\$34.00",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$34.00",
              "focus": false,
              "dropdown": <String, dynamic>{},
              "operation": "sum",
              "field": 1
            }
          },
          {
            "text": "\$70.00",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$70.00",
              "focus": false,
              "dropdown": <String, dynamic>{},
              "operation": "sum",
              "field": 2
            }
          }
        ]
      },
      {
        "tds": [
          {
            "text": "\$30.00",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$30.00",
              "focus": false,
              "operation": "sub",
              "subs": [
                {
                  "row": 0,
                  "cell": 0
                },
                {
                  "row": 0,
                  "cell": 1
                }
              ]
            }
          },
          {
            "text": "2",
            "style": <String, dynamic>{},
            "obj": {
              "text": "2",
              "focus": false
            }
          },
          {
            "text": "\$1.28",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$1.28",
              "focus": false,
              "operation": "percent",
              "field": 0,
              "cell": 1
            }
          }
        ]
      },
      {
        "tds": [
          {
            "text": "\$67.92",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$67.92",
              "focus": false,
              "operation": "cell_addition",
              "field": {
                "row": 0,
                "cell": 0
              },
              "cell": 0,
              "additions": [
                {
                  "row": 0,
                  "cell": 0
                },
                {
                  "row": 1,
                  "cell": 1
                },
                {
                  "row": 2,
                  "cell": 2
                }
              ]
            }
          },
          {
            "text": "3",
            "style": <String, dynamic>{},
            "obj": {
              "text": "3",
              "focus": false
            }
          },
          {
            "text": "\$1.92",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$1.92",
              "focus": false,
              "operation": "percent_cell",
              "field": {
                "row": 0,
                "cell": 0
              },
              "cell": 1
            }
          }
        ]
      },
      {
        "tds": [
          {
            "text": "\$81",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$81",
              "focus": false,
              "operation": "none",
              "field": null
            }
          },
          {
            "text": "6",
            "style": <String, dynamic>{},
            "obj": {
              "text": "6",
              "focus": false
            }
          },
          {
            "text": "\$72.00",
            "style": <String, dynamic>{},
            "obj": {
              "text": "\$72.00",
              "focus": false,
              "operation": "cell_mul",
              "mul": {
                "first": 0,
                "second": 1
              }
            }
          }
        ]
      },
      {
        "tds": [
          {
            "text": "abc",
            "style": <String, dynamic>{},
            "obj": {
              "text": "abc",
              "focus": false,
              "dropdown": <String, dynamic>{},
              "operation": "sum",
              "field": 0
            }
          },
          {
            "text": "",
            "style": <String, dynamic>{},
            "obj": {
              "text": "",
              "focus": false,
              "dropdown": <String, dynamic>{},
              "operation": "sum",
              "field": 1
            }
          },
          {
            "text": "",
            "style": <String, dynamic>{},
            "obj": {
              "text": "",
              "focus": false,
              "dropdown": <String, dynamic>{},
              "operation": "sum",
              "field": 2
            }
          }
        ]
      },
    ],
    "other": {
      "rule": <String, dynamic>{},
      "tableId": ""
    }
  };
}