# tnt-web
Simple web service based on [tarantool](https://www.tarantool.io/en/doc/latest/getting_started/)

#### What's inside

Simple key-value storage in tarantool available via http.


#### Routes

```
POST    /item             Add key-value pair
                            - 409 if key exist
                            - 400 if body incorrect

PUT     /item/{item_id}   Update data related to key
                            - 400 if body incorrect
                            - 404 if key not exist

GET     /item/{item_id}   Get data by key
                            - 404 if key not exist

DELETE  /item/{item_id}   Delete item by key
                            - 404 if key not exist
```


#### Contacts

- Telegram - [@grit4in](https://t.me/grit4in)

[Up](#tnt-web)
