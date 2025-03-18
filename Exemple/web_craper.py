from fastapi import FastAPI
import time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
import json

app = FastAPI()


def trading_economics_td():
    chrome_options = Options()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-dev-shm-usage')

    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
    url = "https://fr.investing.com/economic-calendar/"
    
    try:
        driver.get(url)
        WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((By.ID, "economicCalendarData"))
        )
        time.sleep(5)  # Optional: Ensure JavaScript is fully loaded

        soup = BeautifulSoup(driver.page_source, 'html.parser')
        table = soup.find('table', {'id': 'economicCalendarData'})

        if table is None:
            raise ValueError("Table with ID 'economicCalendarData' not found on the page.")

        data = []
        rows = table.find_all('tr', class_='js-event-item')

        if not rows:
            raise ValueError("No rows found in the economic calendar table.")

        for row in rows:
            cols = row.find_all('td')
            if len(cols) >= 7:
                data.append([
                    cols[0].text.strip(),
                    cols[1].text.strip(),
                    cols[2].get('title', ''),
                    cols[3].text.strip(),
                    cols[4].text.strip(),
                    cols[6].text.strip()
                ])

        df = pd.DataFrame(data, columns=['Time', 'Currency', 'Volatility', 'Event', 'Actual', 'Previous'])
        return df.to_dict(orient='records')

    except Exception as e:
        # Log or print the exception message
        print(f"An error occurred: {str(e)}")
        # You can also log this error to a file or a logging service if needed
        return {"error": f"An error occurred: {str(e)}"}

    finally:
        driver.quit()

@app.get("/economics_td")
def get_economics_td():
    data = trading_economics_td()
    return {"data": data}
