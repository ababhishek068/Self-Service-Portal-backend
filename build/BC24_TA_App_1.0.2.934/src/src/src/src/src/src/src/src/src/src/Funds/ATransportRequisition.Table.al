Table 50701 "A-Transport Requisition"
{


    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; "Request Date"; Date) { }
        field(3; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(4; "Station Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(5; "Officer No."; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if Emp.Get("Officer No.") then begin
                    "Officer Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    Designation := Emp."Job Title";
                end;
            end;
        }
        field(6; "Officer Name"; Text[50]) { }
        field(7; Designation; Code[20]) { }
        field(8; "Type of Vehicle"; Code[20])
        {
            TableRelation = "A-Vehicle Types".Code;
        }
        field(9; "Local Running"; Boolean) { }
        field(10; Places; Code[200]) { }
        field(11; "Estimated Period (Days)"; Integer) { }
        field(12; "Journey Purpose"; Text[200]) { }
        field(13; Status; Option)
        {
            OptionCaption = 'New,1st Approval,2nd Approval,3rd Approval,4th Approval';
            OptionMembers = New,"1st Approval","2nd Approval","3rd Approval","4th Approval";
        }
        field(14; "Requested By"; Code[20]) { }
        field(15; "HOD Approved By"; Code[20]) { }
        field(16; "HOD Approval date"; Date) { }
        field(17; "HOD Approval Status"; Option)
        {
            OptionCaption = ' ,Approve,Reject';
            OptionMembers = " ",Approve,Reject;
        }
        field(18; "Transport Approved By"; Code[20]) { }
        field(19; "Transport Approval Date"; Date) { }
        field(20; "Transport Approval Status"; Option)
        {
            OptionCaption = ' ,Approve,Reject';
            OptionMembers = " ",Approve,Reject;
        }
        field(21; "MD Approved By"; Code[20]) { }
        field(22; "MD Approval Status"; Option)
        {
            OptionCaption = ' ,Approve,Reject';
            OptionMembers = " ",Approve,Reject;
        }
        field(23; "MD Approval Date"; Date) { }
        field(24; "User Remarks"; Text[200]) { }
        field(25; "HOD Remarks"; Text[200]) { }
        field(26; "Transport Remarks"; Text[200]) { }
        field(27; "MD Remarks"; Text[200]) { }
        field(28; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(29; "Requisition Type"; Option)
        {
            OptionCaption = 'Normal,Commercial';
            OptionMembers = Normal,Commercial;
        }
        field(30; "Client No."; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if Cust.Get("Client No.") then
                    "Client Name" := Cust.Name;
            end;
        }
        field(31; "Client Name"; Text[100]) { }
        field(32; "Approver ID"; Code[20]) { }
        field(33; Distance; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                OPSetUp.GET(0);
                "Estimated Cost":=(Distance*OPSetUp."Est. Driver Cost Per Km.")+(Distance*OPSetUp."Est. Running Cost Per Km")+
                (Distance*OPSetUp."Est. Fuel Cost Per km");
                */

            end;
        }
        field(34; "Estimated Cost"; Decimal) { }
        field(35; "Actual Cost"; Decimal) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*
        IF "No." = '' THEN BEGIN
          OPSetUp.GET(0);
          OPSetUp.TESTFIELD(OPSetUp.Description);
          NoSeriesMgt.GetNextNo(OPSetUp.Description,xRec."No. Series",0D,"No.","No. Series");
        END;
        */

    end;

    var
        Emp: Record Employee;
        Cust: Record Customer;
}

