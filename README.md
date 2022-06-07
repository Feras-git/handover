# handover

A Flutter project that simulate relation between a customer who orders a package, and a driver who carry the package to customer.

If you registered as a customer, you can:
- Select your package.
- Wait for a driver to get responsibility of your order.
- Track the driver on map and getting info of his journey in a bottom sheet.
- Receive the order, and rate the service.

If you registered as a driver, you can:
- See the waiting orders list with the distance to the customer's destination.
- Pick an order from the list, and be routed to the map screen.
- Go to the pick up area to bring the order and then to the customer's destination to deliver the order.

The driver's side sends a notification to the customer side in the following scenarios:
- When the driver is near the pickup destination (5 Km).
- When the driver has arrived to the pick up destination (100 m).
- When the driver is near the delivery destination (5 Km).
- When the driver has arrived to the delivery destination (100 m).

Frontend: Flutter.
Backend: Firebase.

# Screenshots:
<p float="left">
  <img src="https://user-images.githubusercontent.com/95289256/172460011-e55cc4e0-0231-429a-ad63-cd183d12eace.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/95289256/172460034-b54aa6f4-a232-4726-a3e8-5aba98c106af.jpg" width="200" /> 
  <img src="https://user-images.githubusercontent.com/95289256/172460052-30209a72-1b91-461f-8792-b0f92550f8b0.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/95289256/172462079-ad6e00d5-2a5e-487e-9dfb-c81358f8c820.jpg" width="200" />
</p>

