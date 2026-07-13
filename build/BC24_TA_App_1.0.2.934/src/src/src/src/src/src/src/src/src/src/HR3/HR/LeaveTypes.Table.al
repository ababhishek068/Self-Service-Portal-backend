Table 50626 "Leave Types"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200]) { }
        field(3; Days; Decimal) { }
        field(4; "Acrue Days"; Boolean) { }
        field(5; "Unlimited Days"; Boolean) { }
        field(6; Gender; Option)
        {
            OptionCaption = 'Both,Male,Female';
            OptionMembers = Both,Male,Female;
        }
        field(7; Balance; Option)
        {
            OptionCaption = 'Ignore,Carry Forward,Convert to Cash';
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(8; "Inclusive of Holidays"; Boolean) { }
        field(9; "Inclusive of Saturday"; Boolean) { }
        field(10; "Inclusive of Sunday"; Boolean) { }
        field(11; "Off/Holidays Days Leave"; Boolean) { }
        field(12; "Max Carry Forward Days"; Decimal)
        {

            trigger OnValidate()
            begin
                if Balance <> Balance::"Carry Forward" then
                    "Max Carry Forward Days" := 0;
            end;
        }
        field(13; "Inclusive of Non Working Days"; Boolean) { }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(15; Applied; Integer)
        {
            // CalcFormula = count("HR Human Resource Comments" where ("Table Line No."=field(Code),

            FieldClass = FlowField;
        }
        field(20;Annual;Boolean){}

        field(21;"Maternity?";Boolean){
            trigger OnValidate()
            begin
                TestField(Annual,false);
            end;
        }
        field(22;"Days before Delivery";Integer){
            MinValue=1;
            trigger OnValidate()
            begin
                TestField("Maternity?",true);
                TestField(Gender,Gender::Female);
            end;
        }
        field(23;"Mourning leave?";Boolean){}
        field(24;"leave without pay";Boolean){}
        field(25;"Years to Consider for Increment";integer){}
        field(26;"No of Days to Increment with";Integer){}
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

