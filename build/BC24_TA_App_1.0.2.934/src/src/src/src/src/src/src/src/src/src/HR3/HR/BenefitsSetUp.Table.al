table 50925 "Benefits SetUp"
{
    Caption = 'Benefits SetUp';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job Id"; Code[20])
        {
            Caption = 'Job Id';
            DataClassification = CustomerContent;
            TableRelation = "HR Jobs"."Job ID";
            trigger OnValidate()
            begin
                hrjobs.Reset();
                ;
                hrjobs.SetRange(hrjobs."Job ID", "Job Id");
                if hrjobs.FindFirst() then begin

                    "Job Family Code" := hrjobs."Job Family Code";
                    "Job Family Description" := hrjobs."Job Family Description";
                    "Job Sub-Family Code" := hrjobs."Job Sub-Family Code";
                    "Job sub-Family Desc" := hrjobs."Job sub-Family Desc";
                end

            end;
        }
        field(2; Grade; Code[20])
        {
            Caption = 'Grade';
            DataClassification = CustomerContent;
            TableRelation = "Sal Grades";
        }
        field(3; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(4; "Basic Pay"; Decimal)
        {
            Caption = 'Basic Pay';
        }
        field(5; "Hardship Allowance"; Decimal)
        {
            Caption = 'Hardship Allowance';
        }

        field(39; "Job Family Code"; code[20])
        {
            Caption = 'Job Family Code';
            TableRelation = "Job Family";
            Editable = false;
        }
        field(40; "Job Family Description"; text[50])
        {
            Caption = 'Job Family Description';
            Editable = false;
        }
        field(41; "Job Sub-Family Code"; code[20])
        {

            Caption = 'Job sub-Family Code';
            TableRelation = "Job Sub Family";
            Editable = false;


        }
        field(42; "Job sub-Family Desc"; text[50])
        {
            Caption = 'Job sub-Family Description';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Job Id", Grade, "Branch Code")
        {
            Clustered = true;
        }
    }
    var
        hrjobs: Record "HR Jobs";
}
