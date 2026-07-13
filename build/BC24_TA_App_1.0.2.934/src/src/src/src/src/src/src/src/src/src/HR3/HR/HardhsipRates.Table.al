table 50929 "Hardhsip Rates"
{
    Caption = 'Hardhsip Rates';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Region Code"; Code[20])
        {
            Caption = 'Region Code';
            NotBlank=true;
            DataClassification = CustomerContent;
            TableRelation =Region.code;

            trigger OnValidate()
            begin
                 branch.Reset();
                 branch.SetRange(branch.Code,rec."Region Code");
                 //branch.SetRange(branch.level,branch.level::Branch);
                 if branch.FindFirst() then begin
                    "Region Name":=branch.Description;
                 end;

               
            end;
        }
        field(2; "Region Name"; Text[50])
        {
            Caption = 'Region Name';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(3; "Rate(%)"; Decimal)
        {
            Caption = 'Rate(%)';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
            hremps: Record "HR-Employee";
            salgrade1: code[50];
            begin
                // TestField("Branch Code");
                // updateemps("Branch Code");
                
                
                hremps.Reset();
                hremps.SetRange(hremps.Status,hremps.Status::Active);
                hremps.SetRange(hremps.Region,rec."Region Code");                
                if hremps.Find('-') then begin
                    repeat                      
                   // Message(hremps.Grade+'-->'+hremps."No.");

                    if (hremps."Job Group"<>'') and (hremps.Grade<>0) then begin
                        
                        hremps.Validate(hremps.grade);
                        

                    end;

                    until hremps.next=0;
                end;
            end;
        }
        field(4; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(5; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(6;Taxed;Boolean){}
    }
    keys
    {
        key(PK; "Region Code")
        {
            Clustered = true;
        }
    }
   trigger OnInsert()
   begin

    "Created By":=UserId;
    "Date Created":=Today;
   end;

    var
        DimVal: Record "Dimension Value";
        branch: Record region;
        emps: Record "HR-Employee";

        procedure updateemps(branch:Code[50]) begin
            emps.Reset();
            emps.SetRange(emps.Status,emps.Status::Active);
            emps.SetRange(emps.Region,rec."Region Code");
            if emps.Find('-') then begin
                repeat
                emps.Validate(grade);
                until emps.next=0;
            end;

        end;
}
