table 50149 "Research Quiz Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Research Questions".code;
            trigger OnValidate()
            var
                RQ: Record "Research Questions";
            begin
                if Rq.get(Code) then
                    Description := Rq.Description;
            end;
        }
        field(4; "Description"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "FeedBack"; option)
        {
            OptionMembers = "Strongly Agree",Agree,Neutral,Disagree,"Strongly Disagree";
            DataClassification = ToBeClassified;

        }
        field(6; "Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Results Type"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Research Results Type"."Results Type";

        }
        field(8; "Results Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Research Results Type".code where("Results Type" = field("Results Type"));

        }
        field(9; "Comments"; text[200])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; No, "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}