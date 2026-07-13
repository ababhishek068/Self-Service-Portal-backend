page 51303 "HMS Pharmacy Header"
{
    PageType = Document;
    SourceTable = "HMS Pharmacy Header";
    SourceTableView = WHERE(Status = CONST(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Pharmacy No."; Rec."Pharmacy No.")
                {
                    ToolTip = 'Specifies the value of the Pharmacy No. field.';
                }
                field("Pharmacy Date"; Rec."Pharmacy Date")
                {
                    ToolTip = 'Specifies the value of the Pharmacy Date field.';
                }
                field("Pharmacy Time"; Rec."Pharmacy Time")
                {
                    ToolTip = 'Specifies the value of the Pharmacy Time field.';
                }
                field("Cash Sale"; Rec."Cash Sale")
                {
                    ToolTip = 'Specifies the value of the Cash Sale field.';
                }

                field("Request Area"; Rec."Request Area")
                {
                    ToolTip = 'Specifies the value of the Request Area field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Surname+' '+""Last Name"""; Rec.Surname + ' ' + Rec."Last Name")
                {
                    Caption = 'Names';
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field("Patient Type"; Rec."Patient Type")
                {
                    ToolTip = 'Specifies the value of the Patient Type field.';
                }
                field("Insurance No"; Rec."Insurance No")
                {
                    Caption = 'Insurance';
                    ToolTip = 'Specifies the value of the Insurance field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("ADM No"; Rec."ADM No")
                {
                    ToolTip = 'Specifies the value of the ADM No field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field("Bill To Customer No."; Rec."Bill To Customer No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bill To Customer No. field.';
                }
                field("Issued By"; Rec."Issued By")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Issued By field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Total Price"; Rec."Total Price")
                {
                    Caption = 'Pharmacy Cost';
                    ToolTip = 'Specifies the value of the Pharmacy Cost field.';
                }

                field("Total PriceOther Charges"; Rec."Total Price")
                {
                    Caption = 'Total Charges';
                    ToolTip = 'Specifies the value of the Total Charges field.';
                }
            }
            part(Control1102760001; "HMS Pharmacy Line")
            {
                SubPageLink = "Pharmacy No." = FIELD("Pharmacy No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Drug Issuance")
                {
                    Caption = 'Post Drug Issuance';
                    Image = Post;
                    ToolTip = 'Executes the Post Drug Issuance action.';

                    trigger OnAction()
                    begin
                        PostItems();
                    end;
                }
                separator(Separator13) { }
                action("Refresh Unit Price")
                {
                    Image = Refresh;
                    ToolTip = 'Executes the Refresh Unit Price action.';

                    trigger OnAction()
                    begin
                        PharmLine.Reset;
                        PharmLine.SetRange(PharmLine."Pharmacy No.", Rec."Pharmacy No.");
                        if PharmLine.Find('-') then begin
                            repeat
                                if PharmLine."Unit Price" = 0 then Error('Please enter the unit price in all lines');
                                ValueEntry.Reset;
                                ValueEntry.SetRange(ValueEntry."Item No.", PharmLine."No.");
                                if ValueEntry.Find('-') then begin
                                    repeat
                                        ValueEntry."Cost per Unit" := PharmLine."Unit Price";
                                        ValueEntry.Modify;
                                    until ValueEntry.Next = 0;
                                end;
                            until PharmLine.Next = 0;

                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin


        Rec.CalcFields("Total Price");
        Rec.CalcFields(Surname);
        Rec.CalcFields("Last Name");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Status := Rec.Status::New;
        Rec."Issued By" := UserId;
        Rec."Pharmacy Date" := Today;
        Rec."Pharmacy Time" := Time;
    end;

    var
        PatientName: Text[100];
        ItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
        HMSSetup: Record "HMS Setup";
        PharmHeader: Record "HMS Pharmacy Header";
        PharmLine: Record "HMS Pharmacy Line";
        Patient: Record "HMS Patient";
        TreatmentLine: Record "HMS Treatment Form Drug";
        ValueEntry: Record "Value Entry";

    procedure PostItems()
    begin
        if Confirm('Do you wish to post the record?', false) = false then begin exit end;
        if PharmHeader."Cash Sale" = true then begin
            PharmHeader.CalcFields("Receipt Count");
            if PharmHeader."Receipt Count" = 0 then Error('Please note that the selected Record has not been receipted');
        end;
        HMSSetup.Reset;
        HMSSetup.Get();
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", HMSSetup."Pharmacy Item Journal Template");
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", HMSSetup."Pharmacy Item Journal Batch");
        if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
        LineNo := 0;
        PharmLine.Reset;
        PharmLine.SetRange(PharmLine."Pharmacy No.", Rec."Pharmacy No.");
        if PharmLine.Find('-') then begin

            repeat
                LineNo := LineNo + 1000;
                ItemJnlLine.Init;
                ItemJnlLine."Journal Template Name" := HMSSetup."Pharmacy Item Journal Template";
                ItemJnlLine."Journal Batch Name" := HMSSetup."Pharmacy Item Journal Batch";
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Posting Date" := Today;
                // if "Patient Type"<>"Patient Type"::Student then
                // ItemJnlLine."Entry Type":=ItemJnlLine."Entry Type"::Sale
                //  else
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
                ItemJnlLine."Document No." := PharmLine."Pharmacy No." + ':' + PharmLine."No.";
                ItemJnlLine."Item No." := PharmLine."No.";
                ItemJnlLine.Validate(ItemJnlLine."Item No.");
                ItemJnlLine."Location Code" := HMSSetup."Pharmacy Location";
                ItemJnlLine.Validate(ItemJnlLine."Location Code");
                ItemJnlLine.Quantity := PharmLine."Issued Quantity";
                ItemJnlLine.Validate(ItemJnlLine.Quantity);
                ItemJnlLine."Unit of Measure Code" := PharmLine."Measuring Unit";
                ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                ItemJnlLine."Unit Amount" := PharmLine."Unit Price";
                ItemJnlLine."Shortcut Dimension 1 Code" := 'MAIN';
                ItemJnlLine."Shortcut Dimension 2 Code" := '01-02-D031';
                // ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                ItemJnlLine.Validate("Shortcut Dimension 1 Code");
                ItemJnlLine.Validate("Shortcut Dimension 2 Code");
                ItemJnlLine.Insert();
                PharmLine.Remaining := PharmLine.Remaining - PharmLine."Issued Units";
                PharmLine.Modify;
                LineNo := LineNo + 1;
                /*Update the treatment lines*/
                TreatmentLine.Reset;
                TreatmentLine.SetRange(TreatmentLine."Treatment No.", Rec."Link No.");
                TreatmentLine.SetRange(TreatmentLine."Drug No.", PharmLine."No.");
                if TreatmentLine.Find('-') then begin
                    TreatmentLine.Issued := true;
                    TreatmentLine.Modify;
                end;
            until PharmLine.Next = 0;
            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Journal Template Name", HMSSetup."Pharmacy Item Journal Template");
            ItemJnlLine.SetRange("Journal Batch Name", HMSSetup."Pharmacy Item Journal Batch");
            if ItemJnlLine.Find('-') then
                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);
            //ERROR('Mtg');
            Rec.Status := Rec.Status::Completed;
            Rec.Modify;
        end;

    end;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName := '';
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
    end;
}

