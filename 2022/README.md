# Freedom 2022

## Main Goals

1. Try to separate the images out as a single database table. (By using hash)
2. Extract and merge those old data, then to let them fit the new data structure.
3. (Optional), add a function to directly sync those data to github.

## Data Structure

### Old One

```
{
    date: '2022-11-28   09:30',
    content: 'Morning',
    images: [image_base64_string1,
             image_base64_string2]
}
```

> In the sqlite database, the `images` column is a json dumps string

## New One

add type in:

```
{
    type: 'qzone', # freedom and so on
    date: '2022-11-28   09:30',
    content: 'Morning',
    images: [image_base64_string1,
             image_base64_string2]
}
```

<!-- ### New One

#### JSON Version, which still has the old data structure, it is used for export and import the data

```
{
    type: 'qzone', # freedom and so on
    date: '2022-11-28   09:30',
    content: 'Morning',
    images: [image_base64_string1,
                image_base64_string2]
}
```

#### sqlite Version

Table1, message_table

```
{
    type: 'qzone', # freedom and so on
    date: '2022-11-28   09:30',
    content: 'Morning',
    images: [hash_string_for_an_base64_image_1,
                hash_string_for_an_base64_image_2]
}
```

> For the table1, for the `images` column, we use the hash value from the `image_table` (which defined in the following).

Table2, image_table

```
{
    hash_id: '5fe5c00', # we use first 31 chars
    base64_image_string: 'VBORw0KGgoAAAANS...'
}
``` -->
