# Ruby version 2.7.4
# Rails version 6.1.0

# 需求
* 請開發一個線上課程的管理後台 API，包含以下功能
  * 課程列表
  * 課程詳細資訊
  * 建立課程
  * 編輯課程
  * 刪除課程

* 測試:
  * 5支API完成相對應的測試
  * Model 欄位驗證測試
  * API server Heroku 網址 
    * https://frozen-beach-98886.herokuapp.com/

# 文件說明

- 專案的架構，API server 的架構邏輯
    - model 分別為  
      - course(課程)
      - chapter(章節)
      - unit(單元)
    - course 會有很多 chapter，所以關聯設定為一對多
    - 每一個 chapter 會有很多 unit  關聯也是設定為一對多
  ---
  - 你對於使用到的第三方 Gem 的理解，以及他們的功能簡介
    - 專案有用到的 Gem 套件
      - acts_as_list gem(https://github.com/brendon/acts_as_list)
        - 對此Gem的理解
          - 套件提供 新增/更新 資料時會自動更新其餘關聯資料的順序值。
        - 功能簡介
          - bundle 後對需要排序的model跑 migration 加上 position欄位，在model設定其提供的語法後，
            便可以在新增或更新資料時，調整關聯的資料的欄位數值，如果沒帶入數值的話，也會幫你自動生成數值。
          - 針對指定的資料使用其提供的方法調整順序
  ---  
  - 你在程式碼中寫註解的原則，遇到什麼狀況會寫註解
    - 如果是針對客制化需求而需要處理比較複雜的邏輯時，方便自己或是其他同事接手 code 時，看到這段可以先從註解來理解大概這段的目的為何。
  ---
  - 當有多種實作方式時，請說明為什麼你會選擇此種方式
    - 章節、單元需要依照需求排序，可以自己手刻跟使用Gem，如果手刻需要處理關聯資料的所有順序檢查驗證，評估後選擇使用Gem，原因是此套件符合現有需求且套件星數蠻高的且也有持續在維護。
  ---
  - 在這份專案中你遇到的困難、問題，以及解決的方法
    - 初期API設計時，因條件只能有五隻API，但需要能同時處理3個model的資料，我以往的經驗API大多都是一隻 API 針對單一model去做操作，最初做法是在其function內依照前端的request body 去對不同model params 分別填入，但會造成controller 程式碼太亂，不好閱讀及維護，便朝著這方面問題尋找有沒有相關方式可以解決，最終找到Rails提供了 Nested Model  "accepts_nested_attributes_for" 方法，此做法可以讓我在課程的controller 用非常簡潔的寫法做到填入課程資料時一同填入章節和單元的資料，並且也會做其欄位驗證。
    - 課程、章節、單元需要被同時建立的需求，原本想法也是一樣放在controller做處理，判斷此request  3個 model params 是不是都有資料，寫完初版後覺得判斷可以拉出去獨立處理，查詢相關資料查到可以用 ActiveModel::Validations 模組提供的驗證方法去做驗證三筆資料是否存在的需求，最終處理方式是把邏輯判斷拉到 FormObject，這樣我只需要在 create function 內把 params 帶進此 formObject 內，便可以得到相同於一般我們使用 object.valid? 的 errors.full_messages 的回傳值。

  
# 使用說明

## 課程列表
  ```ruby
  #url: https://frozen-beach-98886.herokuapp.com/api/v1/courses
  #method: GET
  ```

回傳狀態和訊息
  ```ruby
  #success
  status: 200
  response_body: 
  {
    "courses": [
      {
        "id": 1,
        "name": "課程1",
        "lecturer": "講師1",
        "description": "這是課程1",
        "chapters": [
          {
            "id": 1,
            "name": "章節1",
            "position": 1,
            "units": [
              {
                "id": 2,
                "name": "章節1-單元1",
                "position": 1,
                "description": "單元2",
                "content": "單元2的內容"
              },...
            ]
          },...
        ]
      },...
    ]
  }
  ```

## 建立課程
  ```ruby
  #url: https://frozen-beach-98886.herokuapp.com/api/v1/courses
  #method: POST

  #chapter、unit position 欄位為 optional 如不帶會依照傳入 params順序填入值
  request_body: 
  {
    "course":{
      "name": STRING,
      "lecturer": STRING,
      "description": STRING,
      "chapters_attributes": [
        {
          "name": STRING,
          "position": INTEGER,
          "units_attributes": [
            {
              "name": STRING,
              "position": INTEGER,
              "description": STRING,
              "content": STRING
            },
            {
              "name": STRING,
              "position": INTEGER,
              "description": STRING,
              "content": STRING
            }
          ]
        },...
      ]
    }
  }
  ```

回傳狀態和訊息
  ```ruby
  #success
  status: 201
  response_body:
  {
    "message": "Create success."
  }
  #failed
  status: 406
  response_body:
  {
    "message": "Create unsuccess.",
    "errors": [
        STRING,...
    ]
  }
  ```

## 課程詳細資訊
  ```ruby
  #url: https://frozen-beach-98886.herokuapp.com/api/v1/courses/:id
  #method: GET
  ```

  回傳狀態和訊息
  ```ruby
  #not found
  status: 404
  response_body:
  {
    "message": "Not found."
  }

  #success
  status: 200
  response_body:
  {
    "course": {
      "id": 1,
      "name": "課程1",
      "lecturer": "講師1",
      "description": "這是課程1",
      "chapters": [
        {
          "id": 1,
          "name": "章節1",
          "position": 1,
          "units": [
            {
              "id": 1,
              "name": "章節1-單元1",
              "position": 1,
              "description": "單元1",
              "content": "單元1的內容"
            },
            {
              "id": 2,
              "name": "章節1-單元2",
              "position": 2,
              "description": "單元2",
              "content": "單元2的內容"
            }
          ]
        },
        {
          "id": 2,
          "name": "章節2",
          "position": 2,
          "units": [
            {
              "id": 3,
              "name": "章節2-單元1",
              "position": 1,
              "description": "單元1",
              "content": "這是單元1的內容"
            },
            {
              "id": 4,
              "name": "章節2-單元2",
              "position": 2,
              "description": "單元2",
              "content": "這是單元2的內容"
            },
            {
              "id": 5,
              "name": "章節2-單元3",
              "position": 3, 
              "description": "單元3",
              "content": "這是單元3的內容"
            }
          ]
        }
      ]
    }
  }
  ```

## 編輯課程
  ```ruby
  #url: https://frozen-beach-98886.herokuapp.com/api/v1/courses/:id
  #method: PATCH

  =begin
  只需帶入欲修改得欄位 key,value
  如需編輯章節需帶入欲編輯章節之 id，否則無法得知要修改的是哪一筆資料
  編輯單元條件同上
  =end

  request_body:
  {
    "course": {
      "name": STRING,
      "lecturer": STRING,
      "description": STRING,
      "chapters": [
        {
          "id": INTEGER,
          "name": STRING,
          "position": INTEGER,
          "units": [
            {
              "id": INTEGER,
              "name": STRING,
              "position": INTEGER,
              "description": STRING,
              "content": STRING
            },...
          ]
        },
        {
          "id": INTEGER,
          "name": STRING,
          "position": INTEGER,
          "units": [
            {
              "id": INTEGER,
              "name": STRING,
              "position": INTEGER,
              "description": STRING,
              "content": STRING
            },...
          ]
        },...
      ]
    }
  }
  ```

回傳狀態和訊息
  ```ruby
  #success
  status: 200
  response_body:
  {
    "message": "Update success."
  }
  #failed
  status: 406
  response_body:
  {
    "message": "Update unsuccess.",
    "errors": [
        STRING,...
    ]
  }
  ```

## 刪除課程
   ```ruby
  #url: https://frozen-beach-98886.herokuapp.com/api/v1/courses/:id
  #method: DELETE
  ```

  回傳狀態和訊息
  ```ruby
  #not found
  status: 404
  response_body:
  {
    "message": "Not found."
  }

  #success
  status: 202
  response_body:
  {
    "message": "Destroy success."
  }

  #failed
  status: 422
  {
    "message": "Destroy unsuccess."
  }
  ```
