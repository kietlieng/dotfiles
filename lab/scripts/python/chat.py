import openai
import os
import pandas as pd
import time

openai.api_key = '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'

openai.api_key = os.getenv("C_API_KEY")


completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
    {"role": "user", "content": "Tell the world about the ChatGPT API in the style of a pirate."}
  ]
)

print(completion.choices[0].message.content)
