drop schema agro_system;

create database agro_system;
	##%character set utf8
	#%#collate utf16_unicode_ci;

use agro_system;

create table states                                                     # Stores the Name of the States
(
    state_id                int(2)             unique auto_increment,
    state_name              varchar(15)        collate utf8_unicode_ci not null,
    
    primary key(state_id)
)charset=utf8 collate=utf8_unicode_ci;

create table districts                                                  # Stores Districts Names
(
    districts_id            int(2)             unique auto_increment,
    districts_name          varchar(15)        collate utf8_unicode_ci not null,
    state_id                int(2)             not null,
    
    primary key(districts_id),
    
    foreign key(state_id) references states(state_id)
    on delete cascade on update cascade
);   
    
create table area                                                       # Stores PIN Codes of Areas/Villages/Town
(
    pin                     char(6)            unique,
    area_name               varchar(15)        collate utf8_unicode_ci not null,
    districts_id            int(3)             not null,
    
    primary key(pin),
    
    foreign key(districts_id) references districts(districts_id)
    on delete cascade on update cascade
);

create table banks                                                      # Stores Bank Names
(
    bank_id                 int(3)             unique auto_increment,
    bank_name               varchar(30)        collate utf8_unicode_ci not null,
    
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
    aadhar_no               char(12),
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
    tool_type               varchar(30)        collate utf8_unicode_ci not null,
    
    primary key(tool_id)
);

create table tool_owners                                                # Stores the list of tool owners who are willing to rent the tools
(
    phone_no                char(10)           not null,
    tool_id                 int(2)             not null,
    tool_name               varchar(20)        collate utf8_unicode_ci not null,
    tool_quantity           int(2)             not null,                # Decrement at runtime or by the user
    tool_price              float              not null,                # Price per day

    primary key(phone_no, tool_id),
    
    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(tool_id) references tools(tool_id)
    on delete cascade on update cascade    
);

create table warehouse_company                                          # Warehouses list
(
    warehouse_id            int(4)             unique auto_increment,
    warehouse_person        char(10)           not null,                # Warehouse Representative registered in our portal
    warehouse_company       varchar(30)       collate utf8_unicode_ci not null,
    warehouse_pin           char(6)            not null,

    primary key(warehouse_id),
    
    foreign key(warehouse_person) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(warehouse_pin) references area(pin)
    on delete cascade on update cascade    
);

create table valueAddition_company                                      # Value Addition company list
(
    va_id                   int(4)             unique auto_increment,
    va_person               char(10)           not null,                # Value Addition Representative registered in our portal
    va_company              varchar(30)        collate utf8_unicode_ci not null,
    va_pin                  char(6)            not null,

    primary key(va_id),
    
    foreign key(va_person) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(va_pin) references area(pin)
    on delete cascade on update cascade    
);

create table logistics_company                                          # Logistics Company list
(
    log_company_id          int(4)             unique auto_increment,
    company_person          char(10)           not null,                # Company Representative
    company_name            varchar(30)        collate utf8_unicode_ci not null,
    company_pin             char(6)            not null,
    ratings                 int,                                        # Ratings out of 5 given by the user

    primary key(log_company_id),
    
    foreign key(company_person) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(company_pin) references area(pin)
    on delete cascade on update cascade    
);

create table occupation
(
    occupation_id           int(2)            not null,
    occupation_name         varchar(20)      collate utf8_unicode_ci  not null,

    primary key(occupation_id)
);

create table user_occupation
(
    phone_no                char(10)          not null,
    occupation_id           int(2)            not null,

    primary key(phone_no, occupation_id),

    foreign key(phone_no) references users(phone_no)
    on delete cascade on update cascade,
    
    foreign key(occupation_id) references occupation(occupation_id)
    on delete cascade on update cascade    
);

create table crop_variety                                               # Stores the crop names and their variety
(
    crop_var_id             int(3)             unique auto_increment,
    crop_name               varchar(20)        collate utf8_unicode_ci not null,                # Name of crop, eg: Cotton
    crop_type               varchar(20)        collate utf8_unicode_ci not null,                # Type of crop, eg: BT

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
    plant_date              date               not null,                # Date of Planting
    crop_harvest_date       date,                                       # Store day to day events, pesticides and fertilizers used in some file, probabily in XML or JASON
    organic_certified       char(1),                                    # Y, N
    weight_after_harvest    float,                                      # Weight in KG
    quality_certi           varchar(20),                                # Certification for quality of crop after harvest by our team, what we will store here -> link to official certificate
    quality_certi_date      date,                                       # Date of quality certification
    questionnaire           varchar(30),                                # Link to the Questionaire files for Data Analysis(JSON) related to production
    active_status           char(1)            not null    default 'Y', # Archived Entry(N) or New(Y)


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
    crop_id                 int(6),                                     # For crop sell, Crop ID, select from the dropdown list of "recent" crops only to avoid the fake quality certificate
    crop_var_id				int(3),										# For Crop Purchase request for wholesellers
    req_pin                 char(6)            not null,                # Location of Crop, independant of user address
    crop_weight             float              not null,                # Weight in KG
    req_accepter            char(10),                                   # Phone Number of request accepter
    accept_price            float,                                      # Accepted price by the bidder
    clearence               char(1),                                    # Clearence(Y/N) from request initiator, that whether he is okay with the request acceptor's deal. Send notification to him after request accepter accepts the request
    entry_time              datetime           not null,                # Time of entry in this table
    accept_time             datetime,                                   # Time of request accept
    clear_time              datetime,                                   # Time of clearence
    reserve_price           int,                                        # Reserve price of the crop
    active_status           char(1)            not null    default 'Y', # Archived Entry(N) or New(Y)
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
    active_status           char(1)            not null    default 'Y', # Archived Entry(N) or New(Y)
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

create table questions
(
    q_id                    int                unique auto_increment,
    q_statement             varchar(100)       not null,
    possible_ans            varchar(100),

    primary key(q_id)
);

create table q_responses
(
    p_id                    char(10)           not null,
    q_id                    int                not null,
    ans_statement           varchar(100),

    primary key(p_id, q_id),

    foreign key(p_id) references users(phone_no)
    on delete cascade on update cascade,

    foreign key(q_id) references questions(q_id)
    on delete cascade on update cascade
);

create table bids                                                       # Table to store auction Bids
(
	crop_request_entry      int(6)             not null,                # Number of Crop to be bid, only those posted bythe Farmer, check crop_var_id == NULL
    trader_no               char(10)           not null,                # Number of the Trader who bids
    bid_amount              int                not null     default 0,

    primary key(crop_request_entry, trader_no),

    foreign key(crop_request_entry) references make_crop_purchase_sell(crop_request_entry)
    on delete cascade on update cascade,

    foreign key(trader_no) references users(phone_no)
    on delete cascade on update cascade
);

# Queries

insert into states (state_id,state_name) values (01,'ગુજરાત');

insert into districts (districts_id,districts_name,state_id) values (01,'અમદાવાદ',01);
insert into districts (districts_id,districts_name,state_id) values (02,'વડોદરા',01);
insert into districts (districts_id,districts_name,state_id) values (03,'સુરત',01);
insert into districts (districts_id,districts_name,state_id) values (04,'ભાવનગર',01);
insert into districts (districts_id,districts_name,state_id) values (05,'કચ્છ',01);
insert into districts (districts_id,districts_name,state_id) values (06,'રાજકોટ',01);
insert into districts (districts_id,districts_name,state_id) values (07,'ગાંધીનગર',01);
insert into districts (districts_id,districts_name,state_id) values (08,'જામનગર',01);
insert into districts (districts_id,districts_name,state_id) values (09,'આનંદ',01);
insert into districts (districts_id,districts_name,state_id) values (10,'મહેસાણા',01);

insert into area (pin, area_name, districts_id) values ('382470','દિગ્વિજયનગર',01);
insert into area (pin, area_name, districts_id) values ('380001','જિલ્લા અદાલત',01);
insert into area (pin, area_name, districts_id) values ('382481','ચાંદોડિયા',01);
insert into area (pin, area_name, districts_id) values ('382330','નરોડા',01);
insert into area (pin, area_name, districts_id) values ('390019','અજવા રોડ',02);
insert into area (pin, area_name, districts_id) values ('390020','અકોટા',02);
insert into area (pin, area_name, districts_id) values ('394651','અગાસવાન',03);
insert into area (pin, area_name, districts_id) values ('394430','અંબાવાડી',03);
insert into area (pin, area_name, districts_id) values ('364710','લેથિડાડ',04);
insert into area (pin, area_name, districts_id) values ('364110','ઘોઘા',04);
insert into area (pin, area_name, districts_id) values ('370110','અંજાર',05);
insert into area (pin, area_name, districts_id) values ('360311','ગોંડલ',06);
insert into area (pin, area_name, districts_id) values ('382721','કલોલ',07);
insert into area (pin, area_name, districts_id) values ('361306','કેશોદ',08);
insert into area (pin, area_name, districts_id) values ('388001','અમુલ ડેરી',09);
insert into area (pin, area_name, districts_id) values ('384170','ઉંઝા',10);

insert into banks (bank_id, bank_name) values (001,'એક્સિસ બેંક');
insert into banks (bank_id, bank_name) values (002,'SBI');
insert into banks (bank_id, bank_name) values (003,'દેના બેંક');
insert into banks (bank_id, bank_name) values (004,'ICICI');
insert into banks (bank_id, bank_name) values (005,'HDFC');
insert into banks (bank_id, bank_name) values (006,'બેન્ક ઓફ બરોડા');
insert into banks (bank_id, bank_name) values (007,'સેન્ટ્રલ બેન્ક ઓફ ઇન્ડિયા');

insert into tools (tool_id, tool_type) values (01,'ટ્રેક્ટર');
insert into tools (tool_id, tool_type) values (02,'ટ્રાન્સપ્લાટર');
insert into tools (tool_id, tool_type) values (03,'કોર્ન હાર્વેસ્ટર');
insert into tools (tool_id, tool_type) values (04,'પોટેટો હાર્વેસ્ટર');
insert into tools (tool_id, tool_type) values (05,'થ્રેશર');
insert into tools (tool_id, tool_type) values (06,'કોટન પીકર');
insert into tools (tool_id, tool_type) values (07,'પાણી નો પંપ');
insert into tools (tool_id, tool_type) values (08,'જનરેટર');
insert into tools (tool_id, tool_type) values (09,'ગ્રાઇં ડ્રાયર');
insert into tools (tool_id, tool_type) values (10,'ટ્રેઇલર સ્પ્રેયર');

insert into crop_variety (crop_var_id, crop_name, crop_type) values (001,'કપાસ','G. Hirsutum');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (002,'કપાસ','G. Arboreum');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (003,'બાઝરા','RHB-121');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (004,'બાઝરા','RHB-90');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (005,'ડાંગર','Basmati Rice');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (006,'ડાંગર','Gujarat 17');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (007,'ઘઉં','GW 173');
insert into crop_variety (crop_var_id, crop_name, crop_type) values (008,'ઘઉં','Raj 3037');

insert into occupation (occupation_id, occupation_name) values (01,'ખેડૂત');
insert into occupation (occupation_id, occupation_name) values (02,'વેપારી');
insert into occupation (occupation_id, occupation_name) values (03,'લોજિસ્ટિક્સ');
insert into occupation (occupation_id, occupation_name) values (04,'સાધનનો માલિક');

# Test Data

insert into users (phone_no, password, first_name, last_name, email_id, address_line_1, address_line_2, gender, pin, dob,online_status) 
values ('9409611733', '12345', 'Deep', 'Patel','deepcpatel@yahoo.in', 'Eden V-302','Godrej Garden City', 'M', '382470', STR_TO_DATE('27-09-1997','%d-%m-%Y'),'Y');

insert into users (phone_no, password, first_name, last_name, email_id, address_line_1, address_line_2, gender, pin, dob,online_status) 
values ('8141724612', '12345', 'Shreyas', 'Patel','shreyasp@gmail.com', '123 Alpha one','Vastrapur', 'M', '382330', STR_TO_DATE('10-03-1997','%d-%m-%Y'),'N');

insert into users (phone_no, password, first_name, last_name, email_id, address_line_1, address_line_2, gender, pin, dob,online_status) 
values ('9409611722', '12345', 'Maunil', 'Vyas','vyasmaunil33@gmail.com', 'Kathwada Road','Naroda', 'M', '382330', STR_TO_DATE('10-11-1996','%d-%m-%Y'),'N');

insert into users (phone_no, password, first_name, last_name, email_id, address_line_1, address_line_2, gender, pin, dob,online_status) 
values ('8609618733', '12345', 'Raj', 'Derasari','rajd@gmail.com', 'Bopal','Ahmedabad', 'M', '382481', STR_TO_DATE('03-02-1997','%d-%m-%Y'),'N');

insert into users (phone_no, password, first_name, last_name, email_id, address_line_1, address_line_2, gender, pin, dob,online_status) 
values ('7989611733', '12345', 'Han', 'Solo','hansolo@starwars.space', 'Optimus','Space Ship', 'M', '382470', STR_TO_DATE('27-09-1954','%d-%m-%Y'),'N');

insert into users (phone_no, password, first_name, last_name, email_id, address_line_1, address_line_2, gender, pin, dob,online_status) 
values ('8706412734', '12345', 'Princess', 'Leia','leiap@starwars.space', 'Space','Universe', 'F', '384170', STR_TO_DATE('27-09-1956','%d-%m-%Y'),'N');

# Test Data

insert into crop_plant_event (phone_no, land_size, land_pin, land_owner_phone, crop_var_id, plant_date)
values ('9409611733', 34, '382330', '9409611722', 003, STR_TO_DATE('03-02-2018','%d-%m-%Y'));

insert into crop_plant_event (phone_no, land_size, land_pin, land_owner_phone, crop_var_id, plant_date)
values ('9409611733', 14, '382470', '9409611733', 002, STR_TO_DATE('27-01-2018','%d-%m-%Y'));

insert into crop_plant_event (phone_no, land_size, land_pin, land_owner_phone, crop_var_id, plant_date)
values ('9409611733', 28, '384170', '8706412734', 002, STR_TO_DATE('15-02-2018','%d-%m-%Y'));

insert into crop_plant_event (phone_no, land_size, land_pin, land_owner_phone, crop_var_id, plant_date)
values ('8609618733', 10, '382481', '9409611722', 001, STR_TO_DATE('10-02-2018','%d-%m-%Y'));

insert into crop_plant_event (phone_no, land_size, land_pin, land_owner_phone, crop_var_id, plant_date)
values ('9409611722', 20, '382481', '9409611722', 003, STR_TO_DATE('07-02-2018','%d-%m-%Y'));

# Test Data

insert into make_crop_purchase_sell(phone_no, req_type, crop_id, req_pin, crop_weight, entry_time, reserve_price)
values ('9409611733', 'S', 1, '382330', 26, '2018-6-14 10:58:46', 23);

insert into make_crop_purchase_sell(phone_no, req_type, crop_id, req_pin, crop_weight, entry_time, reserve_price)
values ('9409611733', 'S', 2, '382470', 30, '2018-8-12 11:00:46', 35);

insert into make_crop_purchase_sell(phone_no, req_type, crop_id, req_pin, crop_weight, entry_time, reserve_price)
values ('8609618733', 'S', 4, '382481', 30, '2018-5-14 09:45:46', 10);

# Test Data

insert into bids(crop_request_entry, trader_no, bid_amount) values (2, '9409611722', 34);
insert into bids(crop_request_entry, trader_no, bid_amount) values (2, '9409611733', 33);
insert into bids(crop_request_entry, trader_no, bid_amount) values (2, '8609618733', 32);
insert into bids(crop_request_entry, trader_no, bid_amount) values (3, '9409611722', 10);
insert into bids(crop_request_entry, trader_no, bid_amount) values (3, '8609618733', 15);
insert into bids(crop_request_entry, trader_no, bid_amount) values (1, '9409611722', 12);

insert into questions(q_statement) values ("What amount of phospate is required for cotton growth at initial level?");
insert into questions(q_statement) values ("How much amount of water you gave to plants last week?");
insert into questions(q_statement) values ("How manytimes did you gave pesticides to the plant?");
insert into questions(q_statement) values ("Nitrogen is best fixed when presence of ___ bacteria?");
insert into questions(q_statement) values ("How many times did you gave phospates tothe crop?");

# Queries

# 1). Auction

select * from (bids natural join (select crop_request_entry, max(bid_amount) as bid_amount from bids group by crop_request_entry) as a);
