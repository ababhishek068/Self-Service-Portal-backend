Page 50818 "HMS Treatment Form Laboratory"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Laboratory";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(LaboratoryTestPackageCode; Rec."Laboratory Test Package Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Test Package Code field.';
                }
                field(LaboratoryTestPackageName; Rec."Laboratory Test Package Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Test Package Name field.';
                }
                field(DateDue; Rec."Date Due")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Due field.';
                }
                field(Results; Rec.Results)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Results field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RequestTests)
            {
                ApplicationArea = Basic;
                Caption = '&Request Tests';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Request Tests action.';

                trigger OnAction()
                begin
                    /*Send the request now?*/


                    if Confirm('Send Laboratory Test Request Now?', false) = true then begin
                        HMSSetup.Reset;
                        HMSSetup.Get();
                        NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Lab Test Request Nos", 0D, true);
                        TreatmentHeader.Reset;
                        TreatmentHeader.Get(Rec."Treatment No.");
                        LabHeader.Reset;
                        LabHeader.Init;
                        LabHeader."Laboratory No." := NewNo;
                        LabHeader."Laboratory Date" := Today;
                        LabHeader."Laboratory Time" := Time;
                        LabHeader."Patient No." := TreatmentHeader."Patient No.";
                        LabHeader."Student No." := TreatmentHeader."Student No.";
                        LabHeader."Employee No." := TreatmentHeader."Employee No.";
                        LabHeader."Relative No." := TreatmentHeader."Relative No.";
                        LabHeader."Request Area" := LabHeader."request area"::Doctor;
                        LabHeader."Link Type" := 'Treatment';
                        LabHeader."Link No." := TreatmentHeader."Treatment No.";
                        labheader2.Reset;
                        labheader2.SetRange(labheader2."Link No.", TreatmentHeader."Treatment No.");
                        if labheader2.Find('-') then begin
                            if Confirm('Record already exist,Confirm Continue?') then LabHeader.Insert;
                        end
                        else begin
                            LabHeader.Insert;
                        end;
                        DocLabRequestLines.Reset;
                        DocLabRequestLines.SetRange(DocLabRequestLines."Treatment No.", Rec."Treatment No.");
                        DocLabRequestLines.SetRange(DocLabRequestLines.Status, DocLabRequestLines.Status::New);
                        if DocLabRequestLines.Find('-') then begin
                            repeat
                                DocLabRequestLines.Status := DocLabRequestLines.Status::Forwarded;
                                DocLabRequestLines.Modify;
                                /*
                                 LabSpecimenSetup.RESET;
                                 LabSpecimenSetup.SETRANGE(LabSpecimenSetup.Test,DocLabRequestLines."Laboratory Test Package Code");
                                    IF LabSpecimenSetup.FIND('-') THEN BEGIN
                                     REPEAT
                                     */
                                LabTestLines.Init;
                                LabTestLines."Laboratory No." := LabHeader."Laboratory No.";
                                //LabTestLines."Laboratory Test Code":=LabSpecimenSetup.Test;
                                LabTestLines."Laboratory Test Code" := DocLabRequestLines."Laboratory Test Package Code";
                                LabTestLines."Specimen Code" := LabSpecimenSetup.Specimen;
                                LabTestLines."Measuring Unit Code" := LabSpecimenSetup."Measuring Unit";
                                //LabTestLines."Laboratory Test Name":=LabSpecimenSetup."Test Name";
                                LabTestLines."Laboratory Test Name" := DocLabRequestLines."Laboratory Test Package Name";

                                LabTestLines."Specimen Name" := LabSpecimenSetup."Specimen Name";
                                LabTestLines.Insert;
                            //  UNTIL LabSpecimenSetup.NEXT=0;
                            // END;

                            /* DocLabRequestLines.reset;
                             DocLabRequestLines.SETRANGE(DocLabRequestLines."Laboratory Test Package Code",LabTestLines."Laboratory Test Code");

                             DocLabRequestLines.find('-') then begin
                               REPEAT
                                 LabTestLines.INIT;
                                // LabTestLines."Laboratory No.":=LabHeader."Laboratory No.";
                                 LabTestLines."Laboratory Test Code":=LabSpecimenSetup.Test;
                                 LabTestLines."Specimen Code":=LabSpecimenSetup.Specimen;
                                 LabTestLines."Measuring Unit Code":=LabSpecimenSetup."Measuring Unit";
                                 LabTestLines."Laboratory Test Name":=LabSpecimenSetup."Test Name";
                                 LabTestLines."Specimen Name":=LabSpecimenSetup."Specimen Name";
                                 LabTestLines.INSERT;
                              UNTIL LabSpecimenSetup.NEXT=0;
                             END;
                                  */
                            // DocLabRequestLines.Status:=DocLabRequestLines.Status::Forwarded;
                            //DocLabRequestLines.MODIFY;
                            until DocLabRequestLines.Next = 0;
                        end
                        else begin
                            Error('Nothing to Forward!');
                        end;


                        /*
                        TreatmentHeader.RESET;
                        TreatmentHeader.SETRANGE(TreatmentHeader."Treatment No.","Treatment No.");
                        IF TreatmentHeader.FIND('-') THEN
                           REPORT.RUN(70135206,TRUE,FALSE,TreatmentHeader);
                        */

                    end;

                end;
            }
        }
    }

    var
        LabHeader: Record "HMS Laboratory Form Header";
        TreatmentHeader: Record "HMS Treatment Form Header";
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
        DocLabRequestLines: Record "HMS Treatment Form Laboratory";
        LabTestLines: Record "HMS Laboratory Test Line";
        LabSpecimenSetup: Record "HMS Setup Test Specimen";
        labheader2: Record "HMS Laboratory Form Header";
}

