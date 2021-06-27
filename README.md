# tnt-web
Simple web service based on [tarantool](https://www.tarantool.io/en/doc/latest/getting_started/)

### What's inside

Simple key-value storage in tarantool available via http.


### Routes

```
POST    /item           Add key-value pair
                            - 409 if key exist
                            - 400 if body incorrect
                            - body: 
                                {
                                    "key": "test", 
                                    "value": {SOME ARBITRARY JSON}
                                }

PUT     /item/:id       Update data related to key
                            - 404 if key not exist
                            - 400 if body incorrect
                            - body: 
                                {
                                    "value": {SOME ARBITRARY JSON}
                                }

GET     /item/:id       Get data by key
                            - 404 if key not exist

DELETE  /item/:id       Delete item by key
                            - 404 if key not exist
```


### Contacts

- Telegram - [@grit4in](https://t.me/grit4in)

[Up](#tnt-web)
