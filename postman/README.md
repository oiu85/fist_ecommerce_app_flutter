# Postman – FakeStore API

Postman collection and environment for **FakeStore API** (v2.1.11).  
Use this to explore and test all endpoints before building the e-commerce Flutter app.

## Files

| File | Purpose |
|------|--------|
| `FakeStore-API.postman_collection.json` | All API requests grouped by: Products, Carts, Users, Auth. Request bodies use **form-data** (no raw JSON). |
| `FakeStore-API.postman_environment.json` | Environment variables: `baseUrl`, `id`, `productId`, `userId`, `cartId`, `token`. |

## Setup

1. **Import in Postman**
   - **Collections:** Import → Upload Files → select `FakeStore-API.postman_collection.json`
   - **Environments:** Import → Upload Files → select `FakeStore-API.postman_environment.json`

2. **Select environment**
   - In the top-right dropdown, choose **FakeStore API - Base**.

3. **Run requests**
   - Open any folder (e.g. **Products**), then run **Get all products** or any other request.
   - For requests that need an ID (e.g. Get single product), set `id` in the environment (default: `1`) or in the request URL/path.

## Collection structure

- **Products** – GET all, GET all categories, GET by category, GET by id, POST (add), PUT (update), DELETE
- **Carts** – GET all, GET by id, POST (add), PUT (update), DELETE
- **Users** – GET all, GET by id, POST (add), PUT (update), DELETE
- **Auth** – POST Login (username + password → token)

All request bodies in the collection use **form-data** (key/value fields).  
If FakeStore returns **400** on POST/PUT (it officially expects `application/json`), switch that request’s body in Postman to **raw** → **JSON** and use the same field names as in the form-data.

## Environment variables

| Variable   | Default                  | Usage |
|-----------|--------------------------|--------|
| `baseUrl` | `https://fakestoreapi.com` | Base URL for all requests. |
| `id`      | `1`                      | Generic path `id` (product/cart/user). |
| `productId` | `1`                   | Product id for cart items. |
| `userId`  | `1`                      | User id for cart/user flows. |
| `cartId`  | `1`                      | Cart id for cart endpoints. |
| `categoryName` | `electronics`       | Category for GET products by category (e.g. `electronics`, `jewelery`, `men's clothing`, `women's clothing`). |
| `token`   | (empty)                  | Optional; set from Login response if you use auth later. |

## API reference

- Docs: [https://fakestoreapi.com/docs](https://fakestoreapi.com/docs)
- OpenAPI: [https://fakestoreapi.com/docs-data](https://fakestoreapi.com/docs-data)
