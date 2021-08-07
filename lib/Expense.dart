class Expense{
  static int maxId=1;
  int id=0;
  DateTime date;
  final String name;
  final String description;
  final int price;

  Expense({required bool update,int? id,required this.date,required this.name,required this.description,required this.price}){

    if(update){//TO Update
      this.id=id!;
    }
    else{
      this.id=maxId;
      maxId++;
    }
  }
}