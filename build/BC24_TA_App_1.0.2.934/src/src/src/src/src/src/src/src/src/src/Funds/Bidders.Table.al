table 50942 Bidders
{
    DrillDownPageId="Bidders List";
    fields
    {
        field(1; "Tender ID"; Code[20])
        {
            Editable=false;
            NotBlank = true;
            TableRelation = "Purchase Quote Header"."No.";
        }
        field(2; "TIN No."; Code[20])
        {
            NotBlank = false;
            //TableRelation = Bidder."PIN No";
            trigger OnValidate()
            begin
                vend.Reset();;
                vend.SetRange(vend."TIN No","TIN No.");
                if vend.FindFirst() then begin
                    Message('Vendor exists in supplier list');
                    "Vendor Number":=vend."No.";
                    "Tenderer Names":=vend.Name;
                    "Vendor exists":=true;

                end;
            end;
        }

        field(3; "Date Created"; Date)
        {
            Editable = false;
            NotBlank = true;
        }
        field(4; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(5; "Receipt No."; Code[20])
        {
            Editable = true;
            NotBlank = true;
        }
        field(8; "Non Refundable Fee"; Decimal)
        {
            Editable = true;
            //MinValue = 1000;
        }
        field(9; Status; Option)
        {
            OptionCaption = 'Open,Undergoing Approval,Approved,Rejected,Cancelled';
            OptionMembers = Open,"Undergoing Approval",Approved,Rejected,Cancelled;
        }
        field(10; Comment; Text[250]) { }
        field(11; "Serial No"; Code[20]) { }
        field(12; "Company E-mail"; Text[50]) { }
        field(13; "Tenderer Names"; Text[70]) { }
        field(14; "Telephone No"; Text[30]) { }
        field(15; "Collection Represe Names"; Text[70]) { 
            Caption='Collection Representative Name';
        }
        field(16; "Tender Name"; Text[200]) { }
        field(17; "Posted To Portal"; Boolean) { }
        field(18; Year; Option)
        {
            OptionCaption = ' ,2025,2026,2027,2028,2029,2030,2031';
            OptionMembers = " ","2025","2026","2027","2028","2029","2030","2031";

        }
        field(19; "Security Bond Amount"; Decimal) { }
        field(20; "Bank Slip Name"; text[50]) {
            Caption='Bank';
         }
        field(21; "Perfomance Bond"; Decimal) { }
        field(22; "Bid Amount"; Decimal)
        {
            caption = 'Bid Amount(Gross)';
        }
        
        field(23;"Vendor exists";Boolean){}
        field(24;"Present on Opening";Boolean){}
        field(25;"Vendor Number";code[20]){
            TableRelation=vendor."No." where (Blocked=filter(false));
        }
        field(26; "Award Status";option)
        {
            OptionMembers="''",Awarded,Rejected;
            trigger OnValidate()
            var
            bidd: record Bidders;
            bidcount: Integer;
            begin
                TestField("Security Bond Amount");
                TestField("Perfomance Bond");
                bidcount:=0;
                bidd.Reset();
                bidd.SetRange(bidd."Tender ID");
                bidd.SetRange(bidd."Award Status",bidd."Award Status"::Awarded);
                if bidd.Find('-') then begin
                    repeat
                    bidcount:=bidcount+1;


                 until bidd.Next=0;

                end;
                if bidcount>1 then begin
                    Error('Only one bidder can be awarded');
                end;
            end;

        }
        field(29;"Reason for fail";Text[20])
        {
             trigger OnValidate()
             begin
                TestField("Reason for fail");
             end;


        }
        field(30;"Bid fail stage";code[20]){
            TableRelation="Tender Plan Lines".Stage where ("Tender No."=field("Tender ID"));
        }
        field(28;"Compliance documents verified?";Boolean)
        {
            
        }
        field(31;"Bank Slip Verified";Boolean){}

        field(32;"Bank Slip Ref No";Code[40]){}
        field(33;"Rpresentative at Openning";text[50]){}
        field(34;"Submitted";Boolean){}
        field(35;"Submitted By";text[50]){}
        field(36;"Bid Bond Verified";Boolean){}
        field(37;"Bid Bond Bank";Text[50]){}
        field(38;"Bid Bond Bank Ref No";Code[40]){}
        field(39;"Technical Evaluation Score";Decimal){
            MaxValue=100;
            MinValue=0;
            trigger OnValidate()
            begin
                Clear("Final Score");
                "Final Score":="Technical Evaluation Score"+"Non-Technical Score"+"Financial Score";
            if "Final Score">100 then
                Error('Final score cannot be more than 100');
            end;
        }
        field(40;"Non-Technical Score";Decimal){
            MaxValue=100;
            MinValue=0;
            trigger OnValidate()
            begin
                Clear("Final Score");
                "Final Score":="Technical Evaluation Score"+"Non-Technical Score"+"Financial Score";
            if "Final Score">100 then
                Error('Final score cannot be more than 100');
            end;
        }
        field(41;"Financial Score";Decimal){
            MaxValue=100;
            MinValue=0;
             trigger OnValidate()
            begin
                Clear("Final Score");
                "Final Score":="Technical Evaluation Score"+"Non-Technical Score"+"Financial Score";
                if "Final Score">100 then
                Error('Final score cannot be more than 100');
                
            
            end;

        }
        field(42;"Final Score";Decimal){
            MaxValue=100;
            
            
        }
        field(43;"Acknowledgement date";date){
            
        }
        field(44;"Expiry date";date)
        {

        }
        field(45;Select;Boolean){}

        
    }
    

    keys
    {
        key(Key1; "Tender ID", "TIN No.")
        {
            Clustered = true;
        }
        key(Key2; "Date Created") { }
        key(Key3; "TIN No.") { }
    }

    

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;
    var
    vend: Record Vendor;

    trigger OnInsert()
    begin
        "Date Created" := Today;
        "Created By" := UserId;
    end;
}



