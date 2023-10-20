# import os module & the OpenAI Python library for calling the OpenAI API
import os
import openai 

# defining Env variable with 'HOME' as value

# setx AZURE_OAI_ENDPOINT ""
# setx AZURE_OAI_KEY ""
# setx AZURE_OAI_MODEL ""

# Get configuration settings
openai.api_key = os.getenv("AZURE_OAI_KEY")
openai.api_base =  os.getenv("AZURE_OAI_ENDPOINT")
openai.api_type = 'azure' # Necessary for using the OpenAI library with Azure OpenAI
openai.api_version = '2023-08-01-preview' # Latest / target version of the API

deployment_name = os.getenv("AZURE_OAI_MODEL") # SDK calls this "engine", but naming it "deployment_name" for clarity

# Send a completion call to generate an answer
print('Sending a test completion job to Azure...')
print(os.getenv("AZURE_OAI_KEY"))
print(os.getenv("AZURE_OAI_MODEL"))
start_phrase = 'Who won the gold medal for Olympic mountainbike in 2008 ? '
response = openai.Completion.create(engine=deployment_name, prompt=start_phrase, max_tokens=50, temperature=0.7)
# text = response['choices'][0]['text'].replace('\n', '').replace(' .', '.').strip()
text = response['choices'][0]['text'].strip()
print(start_phrase+text)