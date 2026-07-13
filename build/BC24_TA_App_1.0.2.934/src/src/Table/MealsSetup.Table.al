Table 50915 "Meals Setup"
{
    // DrillDownPageID = UnknownPage70135429;
    // LookupPageID = UnknownPage70135429;

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Discription; Text[250]) { }
        field(3; Category; Option)
        {
            OptionCaption = 'Main Dishes,Snacks,Breakfast,Function,Non-food';
            OptionMembers = "Main Dishes",Snacks,Breakfast,"Function","Non-food";
        }
        field(4; "Food Value"; Option)
        {
            OptionMembers = Vitamin,Proteins,Cabohydrates;
        }
        field(5; Price; Decimal) { }
        field(6; Type; Option)
        {
            OptionCaption = 'Cafeteria,Meal Booking,Sales';
            OptionMembers = Cafeteria,"Meal Booking",Sales;
        }
        field(7; "Line No"; Integer)
        {
            AutoIncrement = false;
        }
        field(8; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(10; "Total Quantity"; Integer)
        {
            CalcFormula = count("Receipt Line q");
            FieldClass = FlowField;
        }
        field(12; "Total Sales"; Decimal)
        {
            CalcFormula = sum("Receipt Line q"."Total Amount");
            FieldClass = FlowField;
        }
        field(13; Active; Boolean) { }
        field(15; "Total Credits"; Decimal) { }
        field(16; "Total Debits"; Decimal) { }
        field(17; "Exclude in Summary"; Boolean) { }
        field(18; "Cash Sales"; Decimal)
        {
            CalcFormula = sum("Receipt Line q"."Total Amount");
            FieldClass = FlowField;
        }
        field(19; "Advance Sales"; Decimal)
        {
            CalcFormula = sum("Receipt Line q"."Total Amount");
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Line No") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        mealJournEntries.Reset;
        mealJournEntries.SetRange(mealJournEntries."Paying Bank No", Code);
        if mealJournEntries.Find('-') then begin
            if Code <> xRec.Code then
                Error('The Meal Cannot be Renamed since it contains entries');
        end;
    end;

    trigger OnInsert()
    begin
        Active := true;
    end;

    trigger OnModify()
    begin
        mealJournEntries.Reset;
        mealJournEntries.SetRange(mealJournEntries."Paying Bank No", Code);
        if mealJournEntries.Find('-') then begin
            if Code <> xRec.Code then
                Error('The Meal Cannot be Renamed since it contains entries');
        end;
    end;

    trigger OnRename()
    begin
        mealJournEntries.Reset;
        mealJournEntries.SetRange(mealJournEntries."Paying Bank No", Code);
        if mealJournEntries.Find('-') then begin
            if Code <> xRec.Code then
                Error('The Meal Cannot be Renamed since it contains entries');
        end;
    end;

    var
        //  mealsdet: Record "Cafeteria Receipts Line";
        mealJournEntries: Record "Payment Schedule";
}

