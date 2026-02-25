import boto3
import time

def monitor_live_cloud_traffic():
    # Connect to LocalStack (Mock AWS) 
    s3 = boto3.client('s3', endpoint_url='http://localhost:4566', region_name='us-east-1')
    
    print("🛡️  Live Cloud Detection Engine Active...")
    print("📡 Monitoring for rapid API requests (Potential Brute Force)...")
    
    request_count = 0
    start_time = time.time()

    # Loop to simulate continuous monitoring
    while request_count < 10:
        try:
            # We use an API call to simulate a network event
            s3.list_buckets()
            request_count += 1
            elapsed = time.time() - start_time
            
            print(f"📊 Request {request_count} detected at {elapsed:.2f}s")
            
            # Intrusion Detection Logic: 
            # If more than 5 requests happen in under 3 seconds, trigger an alert
            if request_count > 5 and elapsed < 3:
                print("🚨 CRITICAL ALERT: Rapid API activity detected! Possible Brute Force Attack.")
                break
                
            time.sleep(0.4) # Simulate time passing between logs
        except Exception as e:
            print(f"⚠️  Monitoring Error: {e}")
            break

if __name__ == "__main__":
    monitor_live_cloud_traffic()
