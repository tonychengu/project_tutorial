# Structure
- Use Firebase
  - provides user authentication
  - provides array contains operations
    - https://cloud.google.com/firestore/docs/query-data/queries

    ```dart
    final citiesRef = db.collection("cities");
    final cities = citiesRef.where("regions", arrayContainsAny: ["west_coast", "east_coast"]);
    ```
