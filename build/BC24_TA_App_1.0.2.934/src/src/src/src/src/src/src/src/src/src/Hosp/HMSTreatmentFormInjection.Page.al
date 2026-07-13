Page 50817 "HMS Treatment Form Injection"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Injection";
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
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(InjectionName; Rec."Injection Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Name field.';
                }
                field(InjectionGiven; Rec."Injection Given")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Given field.';
                }
                field(InjectionUnitofMeasure; Rec."Injection Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Unit of Measure field.';
                }
                field(InjectionQuantity; Rec."Injection Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Quantity field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field(InjectionRemarks; Rec."Injection Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Remarks field.';
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
                    /*
                    IF CONFIRM('Do you wish to post the record?',FALSE)=FALSE THEN BEGIN EXIT END;
                    HMSSetup.RESET;
                    HMSSetup.GET();
                    ItemJnlLine.RESET;
                    ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name",HMSSetup."Doctor Item Journal Template");
                    ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name",HMSSetup."Doctor Item Journal Batch");
                    IF ItemJnlLine.FIND('-') THEN ItemJnlLine.DELETEALL;
                    LineNo:=1000;
                    PharmLine.RESET;
                    PharmLine.SETRANGE(PharmLine."Treatment No.","Treatment No.");
                    PharmLine.SETRANGE(PharmLine.Posted,FALSE);
                    IF PharmLine.FIND('-') THEN
                      BEGIN
                        REPEAT
                    
                           ItemJnlLine.INIT;
                            ItemJnlLine."Journal Template Name":=HMSSetup."Doctor Item Journal Template";
                            ItemJnlLine."Journal Batch Name":=HMSSetup."Doctor Item Journal Batch";
                            ItemJnlLine."Line No.":=LineNo;
                            ItemJnlLine."Posting Date":=TODAY;
                            ItemJnlLine."Entry Type":=ItemJnlLine."Entry Type"::"Negative Adjmt.";
                            PharmLine.CALCFIELDS(PharmLine."Item No.");
                            ItemJnlLine."Document No.":=PharmLine."Treatment No." + ':' + PharmLine."Item No.";
                            ItemJnlLine."Item No.":=PharmLine."Item No.";
                            ItemJnlLine.VALIDATE(ItemJnlLine."Item No.");
                            ItemJnlLine."Location Code":=HMSSetup."Doctor Room";
                            ItemJnlLine.VALIDATE(ItemJnlLine."Location Code");
                            ItemJnlLine.Quantity:="Injection Quantity";
                            ItemJnlLine.VALIDATE(ItemJnlLine.Quantity);
                            ItemJnlLine."Unit of Measure Code":="Injection Unit of Measure";
                            ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code");
                            ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                           ItemJnlLine.INSERT();
                           PharmLine.Posted:=TRUE;
                           PharmLine.MODIFY;
                           LineNo:=LineNo + 1;
                           {Update the treatment lines}
                        UNTIL PharmLine.NEXT=0;
                        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post Batch",ItemJnlLine);
                    
                    
                      END;
                      */
                    if Confirm('Alert Pharmacy About Prescription?') = false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Pharmacy Nos", 0D, true);

                    /*Get the treatment from the database*/
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get(Rec."Treatment No.") then begin
                        PharmHeader.Reset;
                        PharmHeader.Init;
                        PharmHeader."Pharmacy No." := NewNo;
                        PharmHeader."Pharmacy Date" := Today;
                        PharmHeader."Pharmacy Time" := Time;
                        PharmHeader."Request Area" := PharmHeader."request area"::Doctor;
                        PharmHeader."Patient No." := TreatmentHeader."Patient No.";
                        PharmHeader."Student No." := TreatmentHeader."Student No.";
                        PharmHeader."Employee No." := TreatmentHeader."Employee No.";
                        PharmHeader."Relative No." := TreatmentHeader."Relative No.";
                        PharmHeader."Link Type" := 'Doctor';
                        PharmHeader."Link No." := Rec."Treatment No.";
                        PharmHeader.Insert();

                        TreatmentLine.Reset;
                        TreatmentLine.SetRange(TreatmentLine."Treatment No.", Rec."Treatment No.");
                        if TreatmentLine.Find('-') then begin
                            repeat
                                PharmLine.Init;
                                PharmLine."Pharmacy No." := NewNo;
                                PharmLine."No." := Rec."Item No.";
                                PharmLine.Quantity := Rec."Injection Quantity";
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine."Measuring Unit" := Rec."Injection Unit of Measure";
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine.Dosage := Rec.Duration;
                                PharmLine.Pharmacy := Rec."Injection No.";
                                PharmLine."Link Code" := TreatmentHeader."Link No.";
                                PharmLine.Insert();
                            until TreatmentLine.Next = 0;
                        end;
                        Message('The Prescription has been sent to the Pharmacy for Issuance. Issue No:' + NewNo);
                    end;

                end;
            }
        }
    }

    var
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
        TreatmentHeader: Record "HMS Treatment Form Header";
        TreatmentLine: Record "HMS Treatment Form Injection";
        PharmHeader: Record "HMS Pharmacy Header";
        PharmLine: Record "HMS Pharmacy Line";
}

