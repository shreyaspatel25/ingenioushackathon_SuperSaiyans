drop schema agro_system;

create database agro_system;

use agro_system;

create table states                                                     # Stores the Name of the States
(
    state_id                int(2)             unique auto_increment,
    state_name              varchar(15)        not null,
    
    primary key(state_id)
);

create table districts                                                  # Stores Districts Names
(
    districts_id            int(2)             unique auto_increment,
    districts_name          varchar(15)        not null,
    state_id                int(2)             not null,
    
    primary key(districts_id),
    
    foreign key(state_id) references states(state_id)
    on delete cascade on update cascade
);   
    
create table area                                                       # Stores PIN Codes of Areas/Villages/Town
(
    pin                     char(6)            unique,
    area_name               varchar(15)        not null,
    districts_id            int(3)             not null,
    
    primary key(pin),
    
    foreign key(districts_id) references districts(districts_id)
    on delete cascade on update cascade
);

create table banks                                                      # Stores Bank Names
(
    bank_id                 int(3)             unique auto_increment,
    bank_name               varchar(30)        not null,
    
    primary key(bank_id)
);

create table users                                                      # Store User Details
(
    phone_no                char(10)           unique not null,         # Serves as user ID as well as phone Number, OTP verification can be done
    password                varchar(20)        not null,
    first_name              char(15)           not null,
    last_name               char(15)           not null,
    email_id                char(30),
    address_line_1          varchar(50)        not null,
    address_line_2          varchar(50),
    gender                  char(1)            not null,                # Give radio button option
    pin                     char(6)            not null,
    dob                     date,
    aadhar_no               int(12),
    online_status           char(1)            not null    default 'N',  # Y/N
    
    primary key(phone_no),
    
    foreign key(pin) references area(pin)
    on delete cascade on update cascade
);

create table financial_details                                          # Stores Financial Details of the Users
(
    phone_no                char(10)           not null,
    bank_id                 int(3)             not null,
    account_no              int(18)            not null,
    
    primary key(phone_no, bank_id, account_no),
    
    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(bank_id) references banks(bank_id)
    on delete cascade on update cascade
); 

create table farmers                                                    # Stores the List of users who are Farmers
(
    phone_no                char(10)           unique not null,
    export_registered       char(1),                                    # Y/N. Registered for exports or not
    
    primary key(phone_no),
    
    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade
);

create table traders                                                    # Stores the List of users who are Traders/Wholesellers
(
    phone_no                char(10)           unique not null,
    address_line_1          varchar(50)        not null,                # Office Address
    address_line_2          varchar(50),
    pin                     char(6)            not null,
    
    primary key(phone_no),
    
    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(pin) references area(pin)
    on delete cascade on update cascade
);

create table tools                                                      # Stores the List of tools used in farming
(
    tool_id                 int(2)             unique auto_increment,
    tool_type               varchar(30)        not null,
    
    primary key(tool_id)
);

create table tool_owners                                                # Stores the list of tool owners who are willing to rent the tools
(
    phone_no                char(10)           not null,
    tool_id                 int(2)             not null,
    tool_name               varchar(20)        not null,
    tool_quantity           int(2)             not null,                # Decrement at runtime or by the user
    tool_price              float              not null,                # Price per day

    primary key(phone_no, tool_id),
    
    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(tool_id) references tools(tool_id)
    on delete cascade on update cascade    
);

create table logistics_company                                          # Logistics Company list
(
    log_company_id          int(4)             unique auto_increment,
    company_person          char(10)           not null,                # Company Representative
    company_name            varchar(30)        not null,
    company_pin             char(6)            not null,
    ratings                 int,                                        # Ratings out of 5 given by the user

    primary key(log_company_id),
    
    foreign key(company_person) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(company_pin) references area(pin)
    on delete cascade on update cascade    
);

create table crop_variety                                               # Stores the crop names and their variety
(
    crop_var_id             int(3)             unique auto_increment,
    crop_name               varchar(20)        not null,                # Name of crop, eg: Cotton
    crop_type               varchar(20)        not null,                # Type of crop, eg: BT

    primary key(crop_var_id)
);

create table crop_plant_event                                           # Stores the crop planting event created by the farmer
(                                                                       # Yet to add insurance
    crop_id                 int(6)             unique auto_increment,
    phone_no                char(10)           not null,
    land_size               int                not null,                # In Hectares, provide options of acres, hectare, vinga, guntha etc.. to farmer, convert internally in the Hectares
    land_pin                char(6)            not null,                # Provide drop down list of area name
    land_owner_phone        char(10),                                   # Useful when farmer is farming on other person's land
    crop_var_id             int(3)             not null,                # Crop Type and Variety
    plant_date              datetime           not null,                # Date of Planting
    crop_harvest_date       datetime,                                   # Store day to day events, pesticides and fertilizers used in some file, probabily in XML or JASON
    organic_certified       char(1),                                    # Y, N
    weight_after_harvest    float,                                      # Weight in KG
    quality_certi           varchar(20),                                # Certification for quality of crop after harvest by our team, what we will store here -> link to official certificate
    quality_certi_date      datetime,                                   # Date of quality certification

    primary key(crop_id),

    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(land_owner_phone) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(land_pin) references area(pin)
    on delete cascade on update cascade,

    foreign key(crop_var_id) references crop_variety(crop_var_id)
    on delete cascade on update cascade
);

create table make_crop_purchase_sell                                    # Table to store the crop purchase and sell requests by the portal members(Farmers and Traders)
(
    crop_request_entry      int(6)             unique auto_increment,
    phone_no                char(10)           not null,                # The user who created the entry
    req_type                char(1)            not null,                # P - Purchase, S - Sell, T - Storage
    crop_id                 int(6)             not null,                # Crop ID, select from the dropdown list of "recent" crops only to avoid the fake quality certificate
    req_pin                 char(6)            not null,                # Location of Crop, independant of user address
    crop_weight             float              not null,                # Weight in KG
    req_accepter            char(10),                                   # Phone Number of request accepter
    clearence               char(1),                                    # Clearence(Y/N) from request initiator, that whether he is okay with the request acceptor's deal. Send notification to him after request accepter accepts the request
    entry_time              datetime           not null,                # Time of entry in this table
    accept_time             datetime,                                   # Time of request accept
    clear_time              datetime,                                   # Time of clearence
    notes                   varchar(100),                               # Notes by request initiator

    primary key(crop_request_entry),

    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(crop_id) references crop_plant_event(crop_id)
    on delete cascade on update cascade,

    foreign key(req_pin) references area(pin)
    on delete cascade on update cascade,

    foreign key(req_accepter) references users(phone_no)
    on delete cascade on update cascade
);

create table crop_shipment_request                                      # Table to invoke logistic service for transportation of crop, whenever the request placed in above table is cleared
(
    shipment_id             int(6)             unique auto_increment,
    crop_request_entry      int(6)             not null,                # Crop Request ID, for which delivery is going to happen
    src_person              char(10)           not null,                # Source
    src_addr                varchar(50)        not null,                # Source Address
    src_pin                 char(6)            not null,                # Source PIN
    w_price                 float,                                      # Price per KM, the source person is willing to pay
    dest_person             char(10)           not null,                # Destination
    dest_addr               varchar(50)        not null,                # Destination Address
    dest_pin                char(6)            not null,                # Destination PIN
    log_company_id          int(4),                                     # Transporter Company, decided when logistics person accepts the shipment order from notification
    trans_price             float,                                      # Price of transportation(Units not fixed ->per KM or fixed). To be entered by the transportes durrinc acceptincance
    trans_time              int,                                        # Estimated Transportation time in days, to be entered by the transporter during acceptance
    clearence               char(1),                                    # Clearence(Y/N) of transporter and his price by the source person
    otp_src                 int(6),                                     # OTP generated after clearence. To be used for the source verification
    otp_dest                int(6),                                     # OTP generated for destination person after clearence. To be used for successfully shipped verification
    good_taken_time         datetime,                                   # Time of goods taken from source user, decided during source OTP verification
    good_shipped_time       datetime,                                   # Time of goods delivered to destination user, decided during dest OTP verification

    primary key(shipment_id),

    foreign key(crop_request_entry) references make_crop_purchase_sell(crop_request_entry)
    on delete cascade on update cascade,

    foreign key(src_person) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(src_pin) references area(pin)
    on delete cascade on update cascade,

    foreign key(dest_person) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(dest_pin) references area(pin)
    on delete cascade on update cascade,

    foreign key(log_company_id) references logistics_company(log_company_id)
    on delete cascade on update cascade
);

create table tool_request                                               # Table to storing entries for tool request
(
    tool_shipment_id        int(6)             unique auto_increment,
    req_person              char(10)           not null,                # Person who is requesting the tool
    req_addr                varchar(50)        not null,                # Requesting Person's Address
    req_pin                 char(6)            not null,                # Requesting Person's PIN
    use_time                float              not null,                # Time required for tool use in days, to be entered by the requesting person
    tool_id                 int(2)             not null,                # Tool type required, for which delivery is going to happen
    w_price                 float,                                      # Price per day, the requesting person is willing to pay
    tool_owner_id           char(10),                                   # Tool owner, decided when tool owner accepts the tool request from notification
    clearence               char(1),                                    # Clearence(Y/N) of tool owner and his price by the source person
    otp_src                 int(6),                                     # OTP generated after clearence. To be used for source verification
    tool_shipped_time       datetime,                                   # Time of Tool delivered to requesting user, decided during source OTP verification
    notes                   varchar(50),                                # To be added by the query acceptor(Contains description about tools like power, etc..)

    primary key(tool_shipment_id),

    foreign key(req_person) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(req_pin) references area(pin)
    on delete cascade on update cascade,

    foreign key(tool_owner_id) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(tool_id) references tools(tool_id)
    on delete cascade on update cascade
);

# Queries

insert into states (state_id,state_name) values (01,'Gujarat');

insert into districts (districts_id,districts_name,state_id) values (01,'Ahmedabad',01);
insert into districts (districts_id,districts_name,state_id) values (02,'Vadodara',01);
insert into districts (districts_id,districts_name,state_id) values (03,'Surat',01);
insert into districts (districts_id,districts_name,state_id) values (04,'Bhavnagar',01);
insert into districts (districts_id,districts_name,state_id) values (05,'Kutch',01);
insert into districts (districts_id,districts_name,state_id) values (06,'Rajkot',01);
insert into districts (districts_id,districts_name,state_id) values (07,'Gandhinagar',01);
insert into districts (districts_id,districts_name,state_id) values (08,'Jamnagar',01);
insert into districts (districts_id,districts_name,state_id) values (09,'Anand',01);
insert into districts (districts_id,districts_name,state_id) values (10,'Mehsana',01);

insert into area (pin, area_name, districts_id) values ('382470','Digvijaynagar',01);
insert into area (pin, area_name, districts_id) values ('380001','District Court',01);
insert into area (pin, area_name, districts_id) values ('382481','Chandlodia',01);
insert into area (pin, area_name, districts_id) values ('382330','Naroda',01);
insert into area (pin, area_name, districts_id) values ('390019','Ajwa Road',02);
insert into area (pin, area_name, districts_id) values ('390020','Akota',02);
insert into area (pin, area_name, districts_id) values ('394651','Agasvan',03);
insert into area (pin, area_name, districts_id) values ('394430','Ambawadi',03);
insert into area (pin, area_name, districts_id) values ('364710','Lathidad',04);
insert into area (pin, area_name, districts_id) values ('364110','Gogha',04);
insert into area (pin, area_name, districts_id) values ('370110','Anjar',05);
insert into area (pin, area_name, districts_id) values ('360311','Gondal',06);
insert into area (pin, area_name, districts_id) values ('382721','Kalol',07);
insert into area (pin, area_name, districts_id) values ('361306','Keshod',08);
insert into area (pin, area_name, districts_id) values ('388001','Amul Dairy',09);
insert into area (pin, area_name, districts_id) values ('384170','Unjha',10);

insert into banks (bank_id, bank_name) values (001,'Axis Bank');
insert into banks (bank_id, bank_name) values (002,'SBI');
insert into banks (bank_id, bank_name) values (003,'Dena Bank');
insert into banks (bank_id, bank_name) values (004,'ICICI');
insert into banks (bank_id, bank_name) values (005,'HDFC');
insert into banks (bank_id, bank_name) values (006,'Bank of Baroda');
insert into banks (bank_id, bank_name) values (007,'Central Bank of India');

insert into tools (tool_id, tool_type) values (01,'Tractor');
insert into tools (tool_id, tool_type) values (02,'Transplanter');
insert into tools (tool_id, tool_type) values (03,'Corn Harvester');
insert into tools (tool_id, tool_type) values (04,'Potato Harvester');
insert into tools (tool_id, tool_type) values (05,'Thresher');
insert into tools (tool_id, tool_type) values (06,'Cotton picker');
insert into tools (tool_id, tool_type) values (07,'Water Pump');
insert into tools (tool_id, tool_type) values (08,'Generator');
insert into tools (tool_id, tool_type) values (09,'Grain dryer');
insert into tools (tool_id, tool_type) values (10,'Trailed Sprayer');

insert into crop_variety (crop_var_id, crop_name, crop_type) values (001,'Cotton','G. Hirsutum');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (002,'Cotton','G. Arboreum');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (003,'Bajra','RHB-121');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (004,'Bajra','RHB-90');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (005,'Rice','Basmati Rice');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (006,'Rice','Gujarat 17');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (007,'Wheat','GW 173');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (008,'Wheat','Raj 3037');





