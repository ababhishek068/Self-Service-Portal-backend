Table 50865 "FLT-Fuel & Maintenance Req."
{
    DrillDownPageID = "FLT Fuel Requestion List";
    LookupPageID = "FLT Fuel Requestion List";

    fields
    {
        field(1; "Requisition No"; Code[20]) { }
        field(2; "Vehicle Reg No"; Code[20])
        {
            TableRelation = "FLT-Vehicle Header"."Registration No.";

            trigger OnValidate()
            var
                vehiclecard: Record "FLT-Vehicle Header";
            begin
                WshpFA.Reset;
                WshpFA.SetRange(WshpFA."Registration No.", "Vehicle Reg No");
                if WshpFA.Find('-') then
                    "Fixed Asset No" := WshpFA."No.";
                if vehiclecard.Get("Vehicle Reg No") then
                    "Type of Fuel" := vehiclecard."Fuel Type";
            end;
        }
        field(3; "Vendor(Dealer)"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vendor.Get("Vendor(Dealer)") then
                    "Vendor Name" := Vendor.Name;
            end;
        }
        field(4; "Quantity of Fuel(Litres)"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Price of Fuel" := "Quantity of Fuel(Litres)" * "Price/Litre";
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(5; "Total Price of Fuel"; Decimal) { }
        field(6; "Odometer Reading"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(7; "Request Date"; Date) { }
        field(8; "Date Taken for Fueling"; Date) { }
        field(9; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Closed,Cancelled;
        }
        field(10; "Prepared By"; Code[20]) { }
        field(11; "Closed By"; Code[20]) { }
        field(12; "Date Closed"; Date) { }
        field(13; "Vendor Invoice No"; Code[20]) { }
        field(14; "Posted Invoice No"; Code[20]) { }
        field(15; Description; Text[250]) { }
        field(16; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));
        }
        field(17; "No. Series"; Code[10]) { }
        field(18; "Vendor Name"; Text[100]) { }
        field(19; "Date Taken for Maintenance"; Date) { }
        field(20; Type; Option)
        {
            OptionMembers = " ",Maintenance,Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Fuel;
        }
        field(21; "Type of Maintenance"; Option)
        {
            OptionMembers = " ",Repair,"Scheduled Service",Tyre;
        }
        field(22; Driver; Code[10])
        {
            TableRelation = "Flt Driver";

            trigger OnValidate()
            begin
                if Drivers.Get(Driver) then begin
                    "Driver Name" := Drivers."Driver Name";
                    "Fuel Card No" := Drivers."Fuel Card No";
                    "Max. Amount Allocated" := Drivers."Fuel Card Max. Value";
                end;
            end;
        }
        field(23; "Driver Name"; Text[100]) { }
        field(24; "Fixed Asset No"; Code[20]) { }
        field(25; Oil; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(26; "Quote No"; Code[20]) { }
        field(27; "Price/Litre"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Price of Fuel" := "Quantity of Fuel(Litres)" * "Price/Litre";
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(28; "Type of Fuel"; Option)
        {
            OptionMembers = " ",Petrol,Diesel;
        }
        field(29; Coolant; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(30; "Battery Water"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(31; "Wheel Alignment"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(32; "Wheel Balancing"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(33; "Car Wash"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Total Price of Fuel" + Oil + Coolant + "Battery Water" + "Wheel Alignment" + "Wheel Balancing" + "Car Wash";
            end;
        }
        field(34; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin
                /*
               TESTFIELD(Status,Status::Open);
               IF NOT UserMgt.CheckRespCenter(1,Department) THEN
                 ERROR(
                   Text001,
                   RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                */

            end;
        }
        field(35; "Maintenance Description"; Text[200]) { }
        field(36; "Total Cost"; Decimal) { }
        field(37; "Oil Type"; Option)
        {
            OptionCaption = ' ,Engine Oil,Brake Fluid,Gear Box Oil';
            OptionMembers = " ","Engine Oil","Brake Fluid","Gear Box Oil";
        }
        field(38; "Oil Litres"; Decimal) { }
        field(39; "Requester ID"; code[20]) { }
        field(40; "Maintenance Type"; Option)
        {
            OptionMembers = "",Normal,Other;
        }
        field(41; "Fuel Card No"; code[20])
        {
            TableRelation = "Fuel Card Setup"."Card No";
        }
        field(42; "Max. Amount Allocated"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Amount Consumed" > 0 then
                    "Amount To be Toped Up" := "Max. Amount Allocated" - "Amount Consumed"
                else
                    "Amount To be Toped Up" := 0;
            end;
        }
        field(43; "Amount Consumed"; Decimal)
        {
            trigger OnValidate()
            begin
                "Amount To be Toped Up" := "Max. Amount Allocated" - "Amount Consumed";
            end;
        }
        field(44; "Amount To be Toped Up"; Decimal) { }
        field(45; "Requisition Type"; Option)
        {
            OptionMembers = "Vehicle Fuel","Vessel Fuel","Machinery Fuel","Fuel Recharge Card";
            OptionCaption = 'Vehicle Fuel,Vessel Fuel,Machinery Fuel,Fuel Recharge Card';
        }
        field(46; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
        }
        field(47; "Last Service Date"; Date) { }
        field(48;"Agreed return Date";Date){}
        field(49;"Exact Return Date";date){
            trigger OnValidate()
            begin
                TestField("Day Received By Garage");
                TestField("Agreed return Date");
            end;
        }
        field(50;"Days at garage";Integer){}
        field(51;"Day Received By Garage";date){
            trigger OnValidate()
            begin
                if ("Day Received By Garage"<>0D) and ("Exact Return Date"<>0D) then begin
                    "Days at garage":="Exact Return Date"-"Day Received By Garage";

                end;
            end;
        }



    }

    keys
    {
        key(Key1; "Requisition No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /* if "Requisition No" = '' then begin
            FltMgtSetup.Get;
            FltMgtSetup.TestField(FltMgtSetup."Maintenance Request");
            NoSeriesMgt.GetNextNo(FltMgtSetup."Maintenance Request", xRec."No. Series", 0D, "Requisition No", "No. Series");
        end; */
        "Request Date" := today;
        "Requester ID" := UserId;

        //END;
    end;

    var
        Vendor: Record Vendor;
        Drivers: Record "Flt Driver";
        WshpFA: Record "FLT-Vehicle Header";
}

