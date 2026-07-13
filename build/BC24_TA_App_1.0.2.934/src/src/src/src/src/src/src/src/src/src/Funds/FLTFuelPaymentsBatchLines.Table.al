Table 50870 "FLTFuel Payments Batch Lines"
{
    DrillDownPageID = "Appraisal Types";
    LookupPageID = "Appraisal Types";

    fields
    {
        field(1; "Requisition No"; Code[20]) { }
        field(2; "Vehicle Reg No"; Code[20])
        {
            TableRelation = "FLT-Vehicle Header"."Registration No.";
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
        field(4; "Quantity of Fuel(Litres)"; Decimal) { }
        field(5; "Value of Fuel"; Decimal) { }
        field(6; "Odometer Reading"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(7; "Request Date"; Date) { }
        field(8; "Date Taken for Fueling"; Date) { }
        field(9; Status; Option)
        {
            OptionMembers = Open,Submitted,Approved,Closed,Cancelled;
        }
        field(10; "Prepared By"; Code[20]) { }
        field(11; "Closed By"; Code[20]) { }
        field(12; "Date Closed"; Date) { }
        field(13; "Vendor Invoice No"; Code[20]) { }
        field(14; "Posted Invoice No"; Code[20]) { }
        field(15; Description; Text[250]) { }
        field(16; Department; Code[20]) { }
        field(17; "No. Series"; Code[10]) { }
        field(18; "Vendor Name"; Text[100]) { }
        field(19; "Date Taken for Maintenance"; Date) { }
        field(20; Type; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel;
        }
        field(21; "Type of Maintenance"; Option)
        {
            OptionMembers = " ",Repair,"Scheduled Service",Tyre;
        }
        field(22; Driver; Code[10])
        {
            TableRelation = "Flt Driver";
        }
        field(23; "Driver Name"; Text[100]) { }
        field(24; "Fixed Asset No"; Code[20]) { }
        field(25; "Litres of Oil"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(26; "Quote No"; Code[20]) { }
        field(50000; Invoiced; Boolean) { }
        field(50001; "Invoice No."; Code[20]) { }
        field(50002; "Payment Batch No"; Code[20]) { }
        field(50003; "Invoiced By"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Payment Batch No", "Requisition No")
        {
            Clustered = true;
            SumIndexFields = "Value of Fuel";
        }
        key(Key2; "Vehicle Reg No")
        {
            SumIndexFields = "Value of Fuel", "Quantity of Fuel(Litres)";
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Type = Type::Order then begin
            if "Requisition No" = '' then begin
                FltMgtSetup.Get;
                FltMgtSetup.TestField(FltMgtSetup."Fuel Register");
                "Requisition No":=NoSeriesMgt.GetNextNo(FltMgtSetup."Fuel Register",0D, true);
            end;
        end else begin
            if Type = Type::Invoice then begin
                if "Requisition No" = '' then begin
                    FltMgtSetup.Get;
                    FltMgtSetup.TestField(FltMgtSetup."Maintenance Request");
                    "Requisition No":=NoSeriesMgt.GetNextNo(FltMgtSetup."Maintenance Request", 0D, true);
                end;
            end;
        end;
    end;

    var
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Vendor: Record Vendor;
}

