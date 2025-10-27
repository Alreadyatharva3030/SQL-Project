# generate_data.py
# Generates CSV files for users, properties, buyers, transactions, etc.
# Usage: python scripts/generate_data.py
# Requires: pip install Faker

from faker import Faker
import csv, random, os, datetime

fake = Faker()
OUTDIR = 'data'
os.makedirs(OUTDIR, exist_ok=True)

NUM_AGENTS = 20
NUM_BUYERS = 100
NUM_PROPERTIES = 1000
NUM_TRANSACTIONS = 300  # a subset of properties sold

def gen_agents():
    with open(os.path.join(OUTDIR,'agents.csv'),'w',newline='',encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['name','contact_no','email','agency_name'])
        for i in range(NUM_AGENTS):
            w.writerow([fake.name(), fake.msisdn()[:10], fake.email(), fake.company()])

def gen_buyers():
    with open(os.path.join(OUTDIR,'buyers.csv'),'w',newline='',encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['name','contact_no','email','budget','preferred_location'])
        for i in range(NUM_BUYERS):
            budget = random.randint(2000000, 50000000)
            w.writerow([fake.name(), fake.msisdn()[:10], fake.email(), budget, fake.city()])

def gen_properties():
    property_types = ['Apartment','Villa','Plot','Independent House']
    cities = ['Mumbai','Pune','Bangalore','Delhi','Chennai','Hyderabad','Kolkata']
    with open(os.path.join(OUTDIR,'properties.csv'),'w',newline='',encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['agent_id','title','location','city','state','price','area_sqft','type','listed_date','status','metadata'])
        for i in range(NUM_PROPERTIES):
            agent_id = random.randint(1, NUM_AGENTS)
            city = random.choice(cities)
            title = f"{random.randint(1,4)}BHK {random.choice(['Flat','Apartment','Home'])} near {fake.street_name()}"
            location = f"{fake.street_address()}, {city}"
            state = 'StateX'
            price = random.randint(2000000, 50000000)
            area = random.randint(300, 4000)
            ptype = random.choice(property_types)
            listed_date = fake.date_between(start_date='-3y', end_date='today').isoformat()
            status = 'Available'
            tags = ','.join(fake.words(nb=3))
            metadata = '{"tags":"%s"}' % tags
            w.writerow([agent_id, title, location, city, state, price, area, ptype, listed_date, status, metadata])

def gen_transactions():
    # produce a subset of property sales
    with open(os.path.join(OUTDIR,'transactions.csv'),'w',newline='',encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['property_id','buyer_id','agent_id','sale_date','sale_price','commission'])
        sold_props = random.sample(range(1, NUM_PROPERTIES+1), NUM_TRANSACTIONS)
        for pid in sold_props:
            buyer_id = random.randint(1, NUM_BUYERS)
            agent_id = random.randint(1, NUM_AGENTS)
            sale_date = fake.date_between(start_date='-2y', end_date='today').isoformat()
            sale_price = random.randint(2000000, 50000000)
            commission = round(sale_price * random.uniform(0.01,0.04),2)
            w.writerow([pid, buyer_id, agent_id, sale_date, sale_price, commission])

if __name__ == '__main__':
    print("Generating agents...")
    gen_agents()
    print("Generating buyers...")
    gen_buyers()
    print("Generating properties...")
    gen_properties()
    print("Generating transactions...")
    gen_transactions()
    print("Done. CSVs saved to data/")
