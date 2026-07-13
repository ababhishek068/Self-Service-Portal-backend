page 51388 "Dipping Header"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Dipping Header";
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Dipping Time"; Rec."Dipping Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dipping Time field.';

                }

            }
            part(DippinLine; "Dipping Lines")
            {
                ApplicationArea = basic;
                SubPageLink = No = field(No), "Station Code" = field("Station Code");
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName1)
            {
                ApplicationArea = All;
                caption = 'Submit Dipping';
                ToolTip = 'Executes the Submit Dipping action.';
                trigger OnAction();
                begin
                    Rec.TestField("Station Code");
                    if Confirm('Do you really want to save the dipping without posting?', false) then begin
                        PostItems();
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.Modify();
                    end;
                end;
            }

        }
    }
    procedure PostItems()
    var
        ItemJnlLine: Record "Dipping Ledger";
        PumpLine: Record "Dipping Lines";
        LineNo: Integer;
        Itm: Record Item;
        FuelType: Record "Fuel Type";
    begin
        ItemJnlLine.RESET;
        ItemJnlLine.SetRange(ItemJnlLine."Document No.", PumpLine.No);
        IF ItemJnlLine.Find('-') THEN
            ItemJnlLine.Delete();

        LineNo := 0;

        PumpLine.Reset;
        PumpLine.SetRange(PumpLine.No, Rec.No);
        if PumpLine.Find('-') then begin
            repeat
                LineNo := LineNo + 1;
                ItemJnlLine.Init;

                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Posting Date" := Today;
                ItemJnlLine.Description := Rec.Description;
                ItemJnlLine."Document Date" := Rec.Date;
                ItemJnlLine."Dipping Time" := Rec."Dipping Time";
                ItemJnlLine."Variance Quantity" := PumpLine."Variance Quantity";
                ItemJnlLine."Variance Amount" := PumpLine."Variant Cost";
                if PumpLine."Variance Quantity" > 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                if PumpLine."Variance Quantity" < 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

                ItemJnlLine."Document No." := PumpLine.No;
                PumpLine.CalcFields("Fuel Type");
                ItemJnlLine."Item No." := PumpLine."Fuel Type";
                ItemJnlLine.Validate(ItemJnlLine."Item No.");
                ItemJnlLine."Location Code" := PumpLine."Tank Code";
                ItemJnlLine.Validate(ItemJnlLine."Location Code");
                ItemJnlLine.Quantity := PumpLine."Variance Quantity";
                ItemJnlLine.Validate(ItemJnlLine.Quantity);
                Itm.get(PumpLine."Fuel Type");
                ItemJnlLine."Unit of Measure Code" := Itm."Base Unit of Measure";
                ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                FuelType.get(PumpLine."Fuel Type");
                ItemJnlLine."Unit Amount" := FuelType."Unit Price";
                ItemJnlLine."Shortcut Dimension 1 Code" := PumpLine."Station Code";
                ItemJnlLine."Shortcut Dimension 2 Code" := 'FORECOURT';
                // ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                ItemJnlLine.Validate("Shortcut Dimension 1 Code");
                ItemJnlLine.Validate("Shortcut Dimension 2 Code");
                ItemJnlLine.Insert();

                LineNo := LineNo + 1;

            until PumpLine.Next = 0;



        end;

    end;
}