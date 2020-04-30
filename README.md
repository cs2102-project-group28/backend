## Run file
- Create an `postgresql` database name `project` and import data from `fds.sql` 
- Run file `main.py` to start server 

## External library
- `psycopg2` to run sql command
- `flask` and `flask-cors` to run backend server

## Function
- Note: Replace param in <> with the specific value
### User Function
#### Login
- `/login`
    + body:
    ```text
    { 
        "username": <username>,
        "password": <password>
    }
    ```
    + return code: 200 for OK and 400 for fail
#### Register
- `/register`
    + body:
    ```text
    { 
        "username": <username>,
        "password": <password>,
        "phone": <8-digit integer>,
        "userType": "customer"/"rider"/"staff"/"manager"
    }
    ```
    + return code: 200 for OK and 400 for fail
#### Update
- `/<username>/update`
    + body: Pass at least 1 of 2 fields in the body below
    ```text
    {
        "password": <password>,
        "phone": <8-digit integer>
    }
    ```
    + return code: 200 for OK and 400 for fail
#### Customer update:
- `/<username>/update/customer`
    + body: Pass at least 1 of 2 fields in the body below
    ```text
    {
        "creditCardNumber": <credit card number>,
        "cvv": <cvv>
    }
    ```
    + return code: 200 for OK and 400 for fail
 
###Customer function
#### View restaurants and food
- `/customer/<username>/order`
    ```text
    {
        "rName": <list of selected restaurants>,
        "rCategory": <list of restaurant categories>,
        "location": <list of location>,
        "fName": <list of food item names>,
        "fCategory": <list of food categories>,
    }
    ```
    + return: information of restaurants, food, and menu
    ```text
    {
        "data": 
        {
          list of json object with keys
            "rid",
            "fid",
            "rName",
            "rCategory",
            "location",
            "minSpent",
            "availability",
            "noOfOrders",
            "price",
            "fName",
            "fCategory" 
        }
    }
    ```
#### Check out
- `/customer/<username>/order/checkout/<rid>/<fid>`
    + body:
    ```text
    {
        "creditCardNumber": <credit card number>,
        "cvv": <cvv>
    }
    ```
    + return:
        - code 400 if credit card or cvv does not match
        - else: price information of the order
        ```text
          {
             "total price",
             "fool price",
             "deliver cost"
          }
        ```
#### View past orders
- `/customer/<username>/past-order/past-order/date?startdate=<startdate>&enddate=<enddate>`
    + `startdate` and `enddate` are optional paramter with format `yyyy-mm-dd`
    + return: all orders of user between `startdate` and `enddate` 
    ```text
    {
        "data": 
        {
          list of json object with keys
            "order time",
            "restaurant",
            "foodItem",
            "price",
            "review"
        }
    }
    ```
#### Search food item / restaurant
- `/customer/<username>/search-food/<item>`
    + return: 
    ```text
    {
      "data": list of food item with substring <item>
    }
    ```

- `/customer/<username>/search-restaurant/<restaurant>`
    + return: 
    ```text
    {
      "data": list of restaurants with name containing substring <restaurant>
        {
          "rName",
          "location"
        }
    }
    ```

### Staff
#### Summary promotion
- `/staff/<username>/summary/promotion/<startdate>/<enddate>`
- `/staff/<username>/summary/promotion/<startdate>`
    + `enddate` is an optional parameter
    + return:
        - code 400 if promotion is found
        - else
        ```text
        {
          "data": list of flat promotion and percentage promotion between startdate and endate
        }
        ```
        Format of flat promotion
        ```text
        {
          'type': 'flat promotion',
          'pid',
          'startDate',
          'endDate',
          'flatAmount',
          'minAmount',
          'rid',
          'no. of orders',
          'orders per day',
          'total price'
        }
        ```
      Format of percentage promotion
        ```text
        {
          'type': 'percentage promotion',
          'pid',
          'startDate',
          'endDate',
          'percentage',
          'maxAmount',
          'rid',
          'no. of orders',
          'orders per day',
          'total price'
        }
        ```
#### View orders in month
- `/staff/<username>/summary/order/<month>/<year>`
    + return:
    ```text
    {
        'total orders',
        'total cost',
        'rName': restaurant managed by staff,
        'location': location of restaurant,
        'favorite food': list of top 5 most-ordered food in month
    }
    ```
### Manager
#### View month summary
- `/manager/<username>/month-summary/<month>/<year>`
    + return:
    ```text
    {
        'new user': number of new user,
        'no. of orders': number of orders in month,
        'total price': total transaction in month,
        'user': [
            {
                'cid': customer id,
                'no. of orders': number of orders by the customer,
                'total price': money purchased by customer
            }
        ]
    }
    ```
#### Order summary
- `/manager/<username>/order/<area>/<day>/<starttime>/<endtime>`
    + return: orders in area in a specific day within a period of time
    ```text
    'no. of order': number of orders,
    'order': list of all orders
    ```
#### Rider sumary
- `/manager/<username>/rider/<month>/<year>`
    - return:
    ```text
    {
      "data":
        "part time": list of part time riders in month
          {
            "type": "part time",
            "uid",
            "no. rating",
            "average rating",
            "no. order",
            "salary",
            "total time",
            "average deliver time"
          },
        "full time": list of full time riders in month
          {
            "type": "full time",
            "uid",
            "no. rating",
            "average rating",
            "no. order",
            "salary",
            "total time",
            "average deliver time"
          },
    }
    ```
### Rider
#### Summary
- `/rider/<username>/summary/<month>/<year>`
    + return:
    ```text
    {
        "type": "part time" / "full time",
        "uid",
        "no. rating",
        "average rating",
        "no. order",
        "salary",
        "total time",
        "average deliver time"
    },
    ```