Table 50819 "HR Job Interview"
{

    fields
    {
        field(1; "Interview Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Interview Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Score; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Total Score"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable=false;
        }
        field(5; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Interviewer; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Interviewer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Experience";Decimal){
            trigger OnValidate()
            begin
                Clear("Total Score");
                "Total Score":=Experience+"Exam/Perfomance"+Interview;
                if "Total Score">100 then begin
                    Error('Total score cannot exceed 100%');
                end;
            end;
        }
        field(9;"Exam/Perfomance";Decimal){
            trigger OnValidate()
            begin
                Clear("Total Score");
                "Total Score":=Experience+"Exam/Perfomance"+Interview;
                if "Total Score">100 then begin
                    Error('Total score cannot exceed 100%');
                end;
            end;
        }
        field(10;Interview;Decimal){
            trigger OnValidate()
            begin
                Clear("Total Score");
                "Total Score":=Experience+"Exam/Perfomance"+Interview;
                if "Total Score">100 then begin
                    Error('Total score cannot exceed 100%');
                end;
            end;
        }
        field(11;"Employee Requisition No";code[20]){}
        
    }

    keys
    {
        key(Key1; "Interview Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

