class CustomerDto {
  CustomerDto({
    this.phone,
    this.name,
    this.address,
    this.numberOfBooks = 0,
    this.paid = 0,
    this.printedWidth = 0,
    this.printedHeight = 0,
    this.shoppingCartCount = 0,
    
  });
  String? name;
  String? phone;
  String? address;
  int? numberOfBooks;
  double? paid;
  int? printedWidth;
  int? printedHeight;
  int ? shoppingCartCount;

  factory CustomerDto.fromJson(Map<String, dynamic> json) => CustomerDto(
    phone: json['phone'] as String?,
    name: json['name'] as String?,
    address: json['address'] as String?,
    numberOfBooks: json['numberOfBooks'] as int?,
    paid: json['paid'] as double?,
    printedWidth: json['printedWidth'] as int? ?? 0,
    printedHeight: json['printedHeight'] as int? ?? 0,
    shoppingCartCount: json['shoppingCartCount'] as int? ?? 0,
  );
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'name': name,
    'address': address,
    'numberOfBooks': numberOfBooks,
    'paid': paid,
    'printedWidth': printedWidth,
    'printedHeight': printedHeight,
    'shoppingCartCount': shoppingCartCount,
  };

  //copy with
  CustomerDto copyWith({
    String? phone,
    String? name,
    String? address,
    List<CustomerDto>? books,
    String? statusBadge,
    int? numberOfBooks,
    double? paid,
    int? printedWidth,
    int? printedHeight,
    int? shoppingCartCount,
  }) {
    return CustomerDto(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      address: address ?? this.address,
      numberOfBooks: numberOfBooks ?? this.numberOfBooks,
      paid: paid ?? this.paid,
      printedWidth: printedWidth ?? this.printedWidth,
      printedHeight: printedHeight ?? this.printedHeight,
      shoppingCartCount: shoppingCartCount ?? this.shoppingCartCount,
    );
  }

  @override
  String toString() {
    return 'CustomerDto{phone: $phone, name: $name, address: $address, numberOfBooks: $numberOfBooks , shoppingCartCount: $shoppingCartCount, paid: $paid, printedWidth: $printedWidth, printedHeight: $printedHeight}';
  }
}
