import csv
import urllib.request
import json

dataset_request = urllib.request.Request('http://localhost:5000/api/action/package_create')
dataset_request.add_header('Authorization', '630de8f5-5c84-463c-9de2-3afefa10ce0d')

with open('sample_data.csv', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        response = urllib.request.urlopen(
            dataset_request,
            json.dumps({
                'owner_org': 'test',
                'name': row['標題'],
                'title': row['標題'],
                'url': row['連結'],
                'tags': [{
                    'name': row['關鍵詞1'],
                    'vocabulary_id': row['關鍵詞1']
                },{
                    'name': row['關鍵詞2'],
                    'vocabulary_id': row['關鍵詞2']
                },{
                    'name': row['關鍵詞3'],
                    'vocabulary_id': row['關鍵詞3']
                }],
                'last_update_date': row['最後更新日期'],
                'start_date': row['數據開始日期'],
                'end_date': row['數據結束日期'],
                'notes': row['註']
            }).encode('utf-8'))

