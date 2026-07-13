Table 50501 "CompanyInfo Questionaire"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(4; "TIN No."; Code[20])
        {
            Editable = true;
        }
        field(5; "Legal Name of Firm"; Text[100]) { }
        field(6; "Post Office Box Number"; Text[50]) { }
        field(7; "Post Code"; Code[20])
        {
            TableRelation = "Post Code".Code;
        }
        field(8; City_Town; Text[30]) { }
        field(9; Country; Code[20])
        {
            TableRelation = "Country/Region".Code;
        }
        field(10; "Physical Location"; Text[100]) { }
        field(11; "City_Town 2"; Text[50]) { }
        field(12; "Country 2"; Code[20])
        {
            TableRelation = "Country/Region".Code;
        }
        field(13; Street; Text[50]) { }
        field(14; "Plot No"; Text[50]) { }
        field(15; "Building Name"; Text[50]) { }
        field(16; "Telephone No"; Text[50]) { }
        field(17; "Fax Number"; Text[50]) { }
        field(18; "Mobile Number"; Text[50]) { }
        field(19; "Out Of Hours Telephone"; Text[50]) { }
        field(20; "Email Address"; Text[50]) { }
        field(21; "Person Of Contact"; Text[50]) { }
        field(22; Title; Text[50]) { }
        field(23; "Current Trade Licence No"; Text[50]) { }
        field(24; "Expiry Date"; Date) { }
        field(25; "Maximum Business Value"; Decimal) { }
        field(26; "Company Directors"; Text[50]) { }
        field(27; "Company Secretary"; Text[50]) { }
        field(28; "General Manager"; Text[50]) { }
        field(29; "Finance Manager"; Text[50]) { }
        field(30; "Company Pharmacist"; Text[50]) { }
        field(31; "Reg. No."; Text[50]) { }
        field(32; "Management Personnel Others"; Text[100]) { }
        field(33; "Sole Proprietor Name"; Text[50]) { }
        field(34; "Sole Proprietor Nationality"; Code[20]) { }
        field(35; "Date Of Start"; Date) { }
        field(36; "Under Management Since"; Date) { }
        field(37; "Net Worth"; Decimal) { }
        field(38; "Bank Reference"; Text[50]) { }
        field(39; "Bonding Company"; Text[100]) { }
        field(40; "Main Activity Fields Summary"; Text[100]) { }
        field(41; "Sup Name"; Text[250]) { }
        field(42; "Sup Address"; Text[50]) { }
        field(43; "Sup Telephone"; Text[30]) { }
        field(44; "Sup Fax"; Text[30]) { }
        field(45; "Sup Email Address"; Text[30]) { }
        field(46; "Sup Cell Phone No"; Text[30]) { }
        field(47; "Sup Education Qualification"; Text[30]) { }
        field(48; "Sup Registration Cerificate No"; Text[30]) { }
        field(49; "Sup Date"; Date) { }
        field(50; "Sup Share Holder_Employee"; Option)
        {
            OptionMembers = "Share Holder",Employee;
        }
        field(51; "Sup Length Of Service"; Decimal) { }
        field(52; "Sup Position Held"; Text[30]) { }
        field(54; "FP Liabilities"; Decimal) { }
        field(55; "FP Assets_Liabilities Date"; Date) { }
        field(56; "FP Assets_Liabilities Summary"; Text[100]) { }
        field(57; "FP Assets"; Decimal) { }
        field(58; "FP Cash Hand"; Decimal) { }
        field(59; "FP Cash Bank"; Decimal) { }
        field(61; "Delivery Logistics"; Text[50]) { }
        field(62; "Lead Time Delivery"; Text[50]) { }
        field(66; "Nature Of Business"; Option)
        {
            OptionCaption = 'Primary Manufacturer,Distributor/Agent,Wholesaler,Retailer,Parent Company,Subsidiary Of Parent Company';
            OptionMembers = "Primary Manufacturer","Distributor/Agent",Wholesaler,Retailer,"Parent Company","Subsidiary Of Parent Company";
        }
        field(67; "Company Name"; Text[100]) { }
        field(68; Signed_By_Names; Text[50]) { }
        field(69; Date; Date) { }
        field(70; "Job Title_Position"; Text[50]) { }
        field(93; "Cert Und We"; Text[30]) { }
        field(94; "Cert Und Tenderer"; Text[30]) { }
        field(95; "Cert Und Address"; Text[30]) { }
        field(96; "Cert Und Telephone"; Text[30]) { }
        field(97; "Cert Und Fax"; Text[30]) { }
        field(98; "Cert Und Email"; Text[30]) { }
        field(99; "Cert Und Mobile"; Text[30]) { }
        field(100; "Cert Und Witness"; Text[30]) { }
        field(101; "Cert Und Address 2"; Text[30]) { }
        field(102; "Cert Und Telephone 2"; Text[30]) { }
        field(103; "Cert Und Fax 2"; Text[30]) { }
        field(104; "TOTO We"; Text[30]) { }
        field(105; "TOTO Contribution Form"; Text[30]) { }
        field(106; "TOTO Tenderer"; Text[30]) { }
        field(107; "TOTO Address"; Text[30]) { }
        field(108; "TOTO Email"; Text[30]) { }
        field(109; "TOTO Telephone"; Text[30]) { }
        field(110; "TOTO Fax"; Text[30]) { }
        field(111; "BD Account No"; Code[20]) { }
        field(112; "BD Account Name"; Text[50]) { }
        field(113; "BD Bank Name"; Text[50]) { }
        field(114; "BD Bank Code"; Text[30]) { }
        field(115; "BD Branch Name"; Text[50]) { }
        field(116; "BD Branch Code"; Text[30]) { }
        field(117; MyRecId; RecordID) { }
        field(118; "TOTO HowDoSuppliersContribute"; Text[30]) { }
    }

    keys
    {
        key(Key1; "TIN No.")
        {
            Clustered = true;
        }
        key(Key2; "Line No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;
}

