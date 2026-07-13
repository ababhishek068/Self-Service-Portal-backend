page 51360 "Posted Dipping Header"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Dipping Header";
    Editable = false;
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
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field.';

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
            action(ActionName)
            {
                ApplicationArea = All;
                caption = 'Post Dipping';
                visible = false;
                ToolTip = 'Executes the Post Dipping action.';
                trigger OnAction();
                begin
                    Rec.TestField("Station Code");
                    if Confirm('Do you really want to post the dipping?', false) then begin
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
        ForeCourt: Record "Fore Court Setup";
        ItemJnlLine: Record "Item Journal Line";
        PumpLine: Record "Dipping Lines";
        LineNo: Integer;
        Itm: Record Item;
        FuelType: Record "Fuel Type";
    begin


        ForeCourt.get;
        ForeCourt.TestField("Item Journal Template");
        ForeCourt.TestField("Item Journal Batch");
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", ForeCourt."Item Journal Template");
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", ForeCourt."Item Journal Batch");
        if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
        LineNo := 0;
        PumpLine.Reset;
        PumpLine.SetRange(PumpLine.No, Rec.No);
        if PumpLine.Find('-') then begin

            repeat
                LineNo := LineNo + 1000;
                ItemJnlLine.Init;
                ItemJnlLine."Journal Template Name" := ForeCourt."Item Journal Template";
                ItemJnlLine."Journal Batch Name" := ForeCourt."Item Journal Batch";
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Posting Date" := Today;
                if PumpLine."Variance Quantity" > 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
                if PumpLine."Variance Quantity" < 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";

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
                // ItemJnlLine."Shortcut Dimension 2 Code" := '01-02-D031';
                // ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                ItemJnlLine.Validate("Shortcut Dimension 1 Code");
                // ItemJnlLine.Validate("Shortcut Dimension 2 Code");
                ItemJnlLine.Insert();

                LineNo := LineNo + 1;

            until PumpLine.Next = 0;

            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Journal Template Name", ForeCourt."Item Journal Template");
            ItemJnlLine.SetRange("Journal Batch Name", ForeCourt."Item Journal Batch");
            if ItemJnlLine.Find('-') then
                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);

        end;

    end;
}