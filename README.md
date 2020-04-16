# JsonUI

## Overview

An open-source platform that helps you render & interact the UI from Json quickly. For an example, we have a QR code look like this:

![](srcs/qrcode.png)

Then it would be decoded to **JsonUI** format:
```json
{
  "version": "1.0.0",
  "requestEndpoint": "https://staging.zentapi.com?formId=123456",
  "requestMethod": "POST",
  "requestHeader": {
    "content-type": "Application/JSON"
  },
  "requestBody": {
    "userId": "$userId",
    "answer": "$selectedValue"
  },
  "formTitle": "The title form",
  "formBody": [
    {
      "label": {
      "string": "How do you think about us?",
      "style": "title"
      }
    },
    {
      "label": {
        "string": "Please choose an interaction bellow to tell about us",
        "style": "body"
      }
    },
    {
      "image": {
        "url": "https://staging.zentapi.com/images?formId=123456"
      }
    },
    {
      "spacing": {
        "style": "normal"
      }
    },
    {
      "answerPicker": {
        "style": "singleChoice",
        "items": ["Very good", "Not really useful"],
        "itemCorrect": [0],
        "titleCorrect": "Thanks for your feedback!",
        "titleWrong": "Opps! So sorry to hear that!",
        "doneButtonTitle": "Done"
      }
    }
  ]
}
```
By using **JsonUI** client apps (iOS & Android), after scanning the QR code above, we get the UI look like this:

![](srcs/rendered.png)

## UI Components

All UI components will be stored in the `formBody` key of json. The value of `formBody` key is an array consists of UI elements.

### Label
Label will be stored in the `label` key inside the `formBody`.   
Label will be rendered as a text with configurations.
