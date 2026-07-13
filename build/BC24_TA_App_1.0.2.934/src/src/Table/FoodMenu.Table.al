Table 50735 "Food Menu"
{


    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[30]) { }
        field(3; "Items Cost"; Decimal)
        {
            CalcFormula = sum("Food Menu Line"."Total Cost" where(Menu = field(Code)));
            FieldClass = FlowField;
        }
        field(4; Type; Option)
        {
            OptionCaption = ' ,Student,Staff,Meal booking';
            OptionMembers = " ",Student,Staff,"Meal booking";

            trigger OnValidate()
            begin
                Amount := "Items Cost" + "Unit Cost";
            end;
        }
        field(5; "Unit Cost"; Decimal) { }
        field(6; Amount; Decimal) { }
        field(7; Quantity; Integer) { }
        field(8; "Units Of Measure"; Text[30]) { }
        field(9; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(10; "Total Quantity"; Decimal)
        {
            CalcFormula = sum("Menu Sales Line".Quantity where(Menu = field(Code),
                                                                Date = field("Date Filter"),
                                                                Posted = const(true)));
            FieldClass = FlowField;
        }
        field(11; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Menu Sales Line".Amount where(Menu = field(Code),
                                                              Date = field("Date Filter"),
                                                              Posted = const(true)));
            FieldClass = FlowField;
        }
        field(12; "Food Category"; Code[30])
        {
            TableRelation = "Food Category".Code;
        }
        field(13; Available; Boolean) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*
          "No. Series Line".RESET;
         MenuSetUp.FINDLAST();
         "No. Series Line".SETRANGE("No. Series Line"."Series Code",MenuSetUp."Menu No. Series");
         IF "No. Series Line".FIND('-')  THEN
         BEGIN
          "Last Code":=INCSTR("No. Series Line"."Last No. Used");
          "No. Series Line"."Last No. Used":="Last Code";
           "No. Series Line".MODIFY;
         END;
         IF "Last Code"='' THEN
         BEGIN
            "Last Code":="No. Series Line"."Starting No.";
            "No. Series Line"."Last No. Used":="Last Code";
            "No. Series Line".MODIFY;
         END;
         Code:="Last Code";
         */

    end;
}

