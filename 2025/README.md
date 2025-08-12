# Freedom 2025

## Main Goals

1. Add confirm window when delete a note.
2. Try to reduce the size of those images in diary. (By using pixel tech)
3. Remove sqlite usage if possible. Use disk_dict pure text.

## Data Structure

### Old One

```
{
    type: 'qzone', # freedom and so on
    date: '2022-11-28   09:30',
    content: 'Morning',
    images: [image_base64_string1,
             image_base64_string2]
}
```

## New One

Maybe convert image_base64_string to 'yingshaoxo_text_image'?