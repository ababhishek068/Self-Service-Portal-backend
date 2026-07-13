Table 50757 "Mail Register"
{
    DrillDownPageID = "Mail Register View";
    LookupPageID = "Mail Register View";

    fields
    {
        field(1; No; code[20])
        {
            Editable = false;
        }
        field(2; "Subject of Doc."; Text[250]) { }
        field(3; "Mail Date"; Date) { }
        field(4; Addressee; Code[50]) { }
        field(5; "mail Time"; Time) { }
        field(6; Receiver; Code[50])
        {
            TableRelation = "HR-Employee";
        }
        field(26; Receiver2; Text[150])
        {
            TableRelation = "HR-Employee";
        }
        field(27; Receiver3; Text[150])
        {
            TableRelation = "HR-Employee";
        }
        field(7; "Addresee Type"; Option)
        {
            OptionMembers = External,Internal;
        }
        field(8; Comments; Text[250]) { }
        field(9; "Doc type"; Option)
        {
            OptionMembers = Normal,Cheque;
        }
        field(10; "Cheque Amount"; Decimal) { }
        field(11; "Direction Type"; Option)
        {
            OptionMembers = "Incoming Mail (Internal)","Incoming Mail (External)","Outgoing Mail (Internal)","Outgoing Mail (External)";
        }
        field(12; "Folio Number"; Code[50]) { }
        field(13; Received; Boolean) { }
        field(14; Dispatched; Boolean) { }
        field(15; "Dispatched by"; Code[50]) { }
        field(16; "stamp cost"; Decimal) { }
        field(17; Email; Text[30]) { }
        field(50000; "Doc Ref No."; Text[30]) { }
        field(50001; "File Tab"; Text[200]) { }
        field(50002; "Folio No"; Code[30])
        {
            TableRelation = "Registry Files"."File No." where("File Status" = filter(New | Active | "Partially Active" | Bring_up));
        }
        field(50003; "Person Recording"; Code[50]) { }
        field(50004; "Delivered By (Mail)"; Text[30]) { }
        field(50005; "Delivered By (Phone)"; Code[10]) { }
        field(50006; "Delivered By (Name)"; Text[50]) { }
        field(50007; "Delivered By (ID)"; Code[10]) { }
        field(50008; "Delivered By (Town)"; Text[150]) { }
        field(50009; "Mail Status"; Option)
        {
            OptionCaption = ',New,Sorting,Dispatch,Sorted,Dispatched';
            OptionMembers = ,New,"Sorting",Dispatch,Sorted,Dispatched;
        }
        field(50010; "Receiving Officer Signature"; Text[150]) { }
        field(50011; "Date Received"; Date) { }
        field(50012; "No. Series"; code[20]) { }




    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }







    trigger OnInsert()
    var
        HRSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        HRSetup.get;
        if No = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Mail Nos");
            No:=NoSeriesMgt.GetNextNo(HRSetup."Mail Nos",0D,true);
        end;
    end;
}

