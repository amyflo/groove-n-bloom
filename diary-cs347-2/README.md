# diary-cs347

First, make sure that you have [Flask](https://flask.palletsprojects.com/en/2.2.x/installation/) installed for your device. If you have [`pip`](https://pypi.org/project/pip/) on your device, you can run `pip install flask` in your CLI. 

You need to install all of the Python 3.0 packages in the preamble of app/src/model_api.py. To get there, copy this into your CLI:`cd app/src`

Make sure you also run `!pip install emoji==1.6.3` to ensure that the text2emotion library runs properly. 

Then, inside of the app/src file, copy these lines into your CLI. 

```
FLASK_ENV=development
flask run
```

This will set up the environment to run the Flask app backend for the journal entry pages. 

Lastly, go back to the outer `app` folder of the react app. To do so, copy this into your CLI: `cd../`

Then, run the react app by using `npm start`.
