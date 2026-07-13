table 50708 "Pump Reading Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Staff No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code where("Global Dimension 1 Code" = field("Station Code"), Active = filter(true), "Active Shift No" = field("Shift No"));
            trigger OnValidate()

            var
                PumpReadingLines: Record "Pump Reading Line";
                ShiftLine: Record "Shift Allocation Line";
            begin
                PumpReadingLines.reset;
                PumpReadingLines.setrange(No, No);
                if PumpReadingLines.find('-') then PumpReadingLines.DeleteAll();

                ShiftLine.reset;
                Shiftline.setrange(No, "Shift No");
                Shiftline.setrange("Staff No", "Staff No");
                if ShiftLine.find('-') then begin
                    repeat
                        PumpReadingLines.init;
                        PumpReadingLines."Pump Code" := ShiftLine."Pump Code";
                        PumpReadingLines."Line No" := ShiftLine."Line No";
                        PumpReadingLines.No := No;
                        PumpReadingLines.validate("Pump Code");
                        PumpReadingLines."Staff No" := "Staff No";
                        PumpReadingLines."Shift No" := "Shift No";
                        PumpReadingLines."Station Code" := "Station Code";
                        PumpReadingLines.insert;
                    until ShiftLine.next = 0;
                end;
            end;
        }
        field(6; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

        }
        field(7; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shift Allocation".No where("Station Code" = field("Station Code"), Open = const(true), Posted = const(false));

        }
        field(8; Description; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(10; Posted; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "No. Series"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Staff Name"; text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Staff No")));

        }
        field(14; "Total Reading Amount"; Decimal)
        {
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            CalcFormula = sum("Pump Reading Line".Amount where(No = field("No")));

        }
        field(15; "Total Invoice Amount"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = sum("Pump Attend. Invoice Alloc.".Amount where(No = field("No")));

        }
        field(21; "Total PumpOut Amount"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Cr.Memo Line"."Amount Including VAT" where("Sell-to Customer No." = field("Staff No"), "Posting Date" = field(Date)));

        }
        field(16; "Total Pump Return Amount"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = sum("Pump Reading Line"."Tank Return Amount" where(No = field("No")));

        }
        field(17; "Total MPESA Amount"; Decimal)
        {

            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = sum("Receipts Header"."Amount Recieved" where("Sales Person" = field("Staff No"), "Shift No" = field("Shift No"), "Pay Mode" = filter(MPESA), Reversed2 = filter(false)));

        }
        field(18; "Total Cash Amount"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;

            CalcFormula = sum("Receipts Header"."Amount Recieved" where("Sales Person" = field("Staff No"), "Shift No" = field("Shift No"), "Pay Mode" = filter(Cash), Reversed2 = filter(false)));

        }
        field(19; "Total PDQ Amount"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = sum("Receipts Header"."Amount Recieved" where("Sales Person" = field("Staff No"), "Shift No" = field("Shift No"), "Pay Mode" = filter(PDQ), Reversed2 = filter(false)));

        }
        field(20; "Total Expenditure"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Line"."Net Amount" where("Shift No" = field("Shift No"), "Global Dimension 1 Code" = field("Station Code")));

        }

    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }
    procedure AssistEdit(OldCust: Record "Pump Reading Header"): Boolean
    var
        Cust: Record "Pump Reading Header";
        SalesSetup: Record "Fore Court Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        Cust := Rec;
        SalesSetup.Get();
        SalesSetup.TestField("Pump Reading Nos");
        Cust."No":= NoSeriesMgt.GetNextNo(SalesSetup."Pump Reading Nos", 0D, true);
            
            OnAssistEditOnBeforeExit(Cust);
            exit(true);
        end;
    

    local procedure OnAssistEditOnBeforeExit(var Customer: Record "Pump Reading Header")
    begin
    end;



    trigger OnInsert()
    var
        GenLedgerSetup: Record "Fore Court Setup";
        NoSeriesMgt: Codeunit "No. Series";
        ShiftAll: Record "Shift Allocation";
    begin
        ShiftAll.reset;
        ShiftAll.setrange(Open, true);
        if not ShiftAll.find('-') then Error('There is no open shift');

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Pump Reading Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Pump Reading Nos", 0D,true);

        end;



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