Page 51050 "HMS Observation Form Dressing"
{
    PageType = ListPart;
    SourceTable = "HMS Observation Dressings";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(ProcessNo; Rec."Process No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PostItemUsage)
            {
                ApplicationArea = Basic;
                Caption = '&Post Item Usage';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Post Item Usage action.';

                trigger OnAction()
                begin
                    if Confirm('Do you wish to post the record?', false) = false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", HMSSetup."Observation Item Journal Temp");
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", HMSSetup."Observation Item Journal Batch");
                    if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
                    LineNo := 1000;
                    PharmLine.Reset;
                    PharmLine.SetRange(PharmLine."Observation No.", Rec."Observation No.");
                    PharmLine.SetRange(PharmLine.Posted, false);
                    if PharmLine.Find('-') then begin
                        repeat
                            ItemJnlLine.Init;
                            ItemJnlLine."Journal Template Name" := HMSSetup."Observation Item Journal Temp";
                            ItemJnlLine."Journal Batch Name" := HMSSetup."Observation Item Journal Batch";
                            ItemJnlLine."Line No." := LineNo;
                            ItemJnlLine."Posting Date" := Today;
                            ItemJnlLine."Entry Type" := ItemJnlLine."entry type"::"Negative Adjmt.";
                            PharmLine.CalcFields(PharmLine."Item No.");
                            ItemJnlLine."Document No." := PharmLine."Observation No." + ':' + PharmLine."Item No.";
                            ItemJnlLine."Item No." := PharmLine."Item No.";
                            ItemJnlLine.Validate(ItemJnlLine."Item No.");
                            ItemJnlLine."Location Code" := HMSSetup."Observation Room";
                            ItemJnlLine.Validate(ItemJnlLine."Location Code");
                            ItemJnlLine.Quantity := PharmLine.Quantity;
                            ItemJnlLine.Validate(ItemJnlLine.Quantity);
                            ItemJnlLine."Unit of Measure Code" := PharmLine."Unit of Measure";
                            ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                            ItemJnlLine.Validate(ItemJnlLine."Unit Amount");
                            ItemJnlLine.Insert();
                            PharmLine.Posted := true;
                            PharmLine.Modify;
                            LineNo := LineNo + 1;
                        /*Update the treatment lines*/
                        until PharmLine.Next = 0;
                        Codeunit.Run(Codeunit::"Item Jnl.-Post Batch", ItemJnlLine);


                    end;

                end;
            }
        }
    }

    var
        HMSSetup: Record "HMS Setup";
        PharmLine: Record "HMS Observation Dressings";
        LineNo: Integer;
        ItemJnlLine: Record "Item Journal Line";
}

