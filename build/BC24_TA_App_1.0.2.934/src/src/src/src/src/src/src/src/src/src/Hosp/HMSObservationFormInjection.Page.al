Page 51048 "HMS Observation Form Injection"
{
    PageType = ListPart;
    SourceTable = "HMS Observation Form Injection";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(InjectionNo; Rec."Injection No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection No. field.';
                }
                field(InjectionName; Rec."Injection Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Injection Name field.';
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(DrugName; Rec."Drug Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Drug Name field.';
                }
                field(ItemUnitOfMeasure; Rec."Item Unit Of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item Unit Of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(InjectionDate; Rec."Injection Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Date field.';
                }
                field(InjectionTime; Rec."Injection Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Time field.';
                }
                field(InjectionRemarks; Rec."Injection Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Remarks field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
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
                            ItemJnlLine."Unit of Measure Code" := PharmLine."Item Unit Of Measure";
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
        ItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
        PharmLine: Record "HMS Observation Form Injection";
}

