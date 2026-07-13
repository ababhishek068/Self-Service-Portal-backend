Report 50255 "HMS Prescription"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSPrescription.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Treatment Form Drug"; "HMS Treatment Form Drug")
        {
            column(ReportForNavId_1; 1) { }
            column(StrNames; StrNames) { }
            column(logos; CompanyInfo.Picture) { }
            column(gender; objPat.Gender) { }
            column(tel1; objPat."Telephone No. 1") { }
            column(ageinyear; objPat."Date Of Birth") { }
            column(todaysDate; todaysDate) { }
            column(TreatmentNo_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Treatment No.") { }
            column(DrugNo_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Drug No.") { }
            column(DrugName_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Drug Name") { }
            column(Quantity_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Quantity) { }
            column(UnitOfMeasure_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Unit Of Measure") { }
            column(Remarks_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Remarks) { }
            column(ActualQuantity_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Actual Quantity") { }
            column(Take_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Take) { }
            column(Route_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Route) { }
            column(Frequency_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Frequency) { }
            column(Dosage_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Take) { }
            column(NumberofDays_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Number of Days") { }

            trigger OnAfterGetRecord()
            begin
                StrNames := '';

                objTreatment.Reset;
                objTreatment.SetRange(objTreatment."Treatment No.", "HMS Treatment Form Drug"."Treatment No.");
                if objTreatment.Find('-') then begin
                    objPat.Reset;
                    objPat.SetRange(objPat."Patient No.", objTreatment."Patient No.");
                    if objPat.Find('-') then begin
                        StrNames := objPat.Surname + ' ' + objPat."Middle Name" + ' ' + objPat."Last Name";
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);

                todaysDate := Today;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        objPat: Record "HMS Patient";
        StrNames: Text;
        CompanyInfo: Record "Company Information";
        objTreatment: Record "HMS Treatment Form Header";
        todaysDate: Date;
}

