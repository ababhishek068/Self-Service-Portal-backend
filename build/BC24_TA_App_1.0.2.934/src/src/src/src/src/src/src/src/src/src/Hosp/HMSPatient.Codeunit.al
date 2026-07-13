Codeunit 50029 "HMS Patient"
{

    trigger OnRun()
    begin
    end;

    var
        Employee: Record "HR-Employee";
        //Relative: Record "HR Employee Kin";
        PatientRec: Record "HMS Patient";
        NewPatientCode: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        HMSSetup: Record "HMS Setup";



    procedure CopyEmployeeToHMS()
    begin
        /*This function copies the employees from the hr module to the hospital management module*/
        Employee.Reset;
        if Employee.Find('-') then begin
            repeat
                /*Check if the patient exists already in the database*/
                PatientRec.Reset;
                PatientRec.SetRange(PatientRec."Patient Type", PatientRec."patient type"::Employee);
                PatientRec.SetRange(PatientRec."Employee No.", Employee."No.");
                if PatientRec.Find('-') then begin
                    /*Patient exists hence do nothing*/
                end
                else begin
                    /*Patient is new*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewPatientCode := NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos", 0D, true);
                    PatientRec.Init;
                    PatientRec."Patient No." := NewPatientCode;
                    PatientRec."Patient Type" := PatientRec."patient type"::Employee;
                    PatientRec."Date Registered" := Today;
                    PatientRec."Employee No." := Employee."No.";
                    PatientRec.Title := Format(Employee.Title);
                    PatientRec.Surname := Employee."First Name";
                    PatientRec."Middle Name" := Employee."Middle Name";
                    PatientRec."Last Name" := Employee."Last Name";
                    PatientRec.Gender := Employee.Gender;
                    PatientRec."Date Of Birth" := Employee."Date Of Birth";
                    PatientRec."Marital Status" := Employee."Marital Status";
                    PatientRec."ID Number" := Employee."ID Number";
                    PatientRec.Photo := Employee.Picture;
                    PatientRec.Email := Employee."E-Mail";
                    PatientRec."Telephone No. 1" := Employee."Home Phone Number" + ',' + Employee."Cellular Phone Number";
                    PatientRec."Telephone No. 2" := Employee."Work Phone Number" + ',' + Employee."Ext.";
                    PatientRec."Correspondence Address 1" := Employee."Postal Address";
                    PatientRec."Correspondence Address 2" := Employee."Residential Address";
                    PatientRec."Correspondence Address 3" := Employee.City + ',' + Employee."Post Code";
                    PatientRec."Fax No." := Employee."Fax Number";
                    PatientRec.Insert();
                end;
            until Employee.Next = 0;
        end;

    end;

    procedure CopyDependantToHMS()
    begin
        /*This function copies the departments from the hr module to the hospital management module*/

        // Relative.Reset;
        // if Relative.Find('-') then begin
        //     repeat
        //         /*Check if the patient exists already in the database*/
        // PatientRec.Reset;
        // PatientRec.SetRange(PatientRec."Patient Type", PatientRec."patient type"::Employee);
        // PatientRec.SetRange(PatientRec."Employee No.", Relative."Employee Code");
        // PatientRec.SetRange(PatientRec.Surname, Relative.SurName);
        // PatientRec.SetRange(PatientRec."Last Name", Relative."Other Names");
        // if PatientRec.Find('-') then begin
        //     /*Patient exists hence do nothing*/
        // end
        // else begin
        //     /*Patient is new*/
        //     HMSSetup.Reset;
        //     HMSSetup.Get();
        //     NewPatientCode := NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos", 0D, true);
        //     PatientRec.Init;
        //     PatientRec."Patient No." := NewPatientCode;
        //     PatientRec."Patient Type" := PatientRec."patient type"::Dependant;
        //     PatientRec."Date Registered" := Today;
        //     PatientRec."Employee No." := Relative."Employee Code";
        //     //          PatientRec."Relative No.":=Relative."Line No.";
        //     PatientRec.Surname := Relative.SurName;
        //     PatientRec."Last Name" := Relative."Other Names";
        //     PatientRec."Telephone No. 1" := Relative."Office Tel No";
        //     PatientRec."Telephone No. 2" := Relative."Home Tel No";
        //     PatientRec."Correspondence Address 1" := Relative.Address;
        //     //          PatientRec."Correspondence Address 2":=Relative."Postal Address2";
        //     //        PatientRec."Correspondence Address 3":=Relative."Postal Address3";
        //     PatientRec.Blocked := true;
        //     PatientRec.Insert();
        // end;
        //     until Relative.Next = 0;



    end;
}

