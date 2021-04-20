       parameter(jdum=2000)
       CHARACTER*200 cfsrdir,clmcfsr
       CHARACTER*200 cfsv2dir,clmcfsv2
       CHARACTER*200 expdir,clmexp
       CHARACTER*200 expname
       CHARACTER*1  kdbug,kgau
       CHARACTER*10 ksyr,ksmth,ksday,kscy,knfdys
       CHARACTER*10 keyr,kemth,keday,kecy,kicy
       CHARACTER*10  kidim,kjdim,kkpds5,kkpds6,kkpds7
c
       dimension deg(jdum), wt(jdum)
c
       call getenv("idbug",kdbug)
       read(kdbug,'(i1)') idbug
       write(*,*) "idbug= ",idbug
c
       call getenv("igau",kgau)
       read(kgau,'(i1)') igau
       write(*,*) "igau= ",igau
C
       call getenv("expname",expname)
       write(*,*) "expname= ",expname
C
       call getenv("cfsrdir",cfsrdir)
       write(*,*) "cfsrdir= ",cfsrdir

       call getenv("clmcfsr",clmcfsr)
       write(*,*) "clmcfsr= ",clmcfsr

       call getenv("cfsv2dir",cfsv2dir)
       write(*,*) "cfsv2dir= ",cfsv2dir

       call getenv("clmcfsv2",clmcfsv2)
       write(*,*) "clmcfsv2= ",clmcfsv2

       call getenv("expdir",expdir)
       write(*,*) "expdir= ",expdir

       call getenv("clmexp",clmexp)
       write(*,*) "clmexp= ",clmexp

       call getenv("syear",ksyr)
       read(ksyr,'(I4)') isyr
       write(*,*) "syear= ",isyr
C
       call getenv("smonth",ksmth)
       read(ksmth,'(I2)') ismth
       write(*,*) "smonth= ",ismth
C
       call getenv("sday",ksday)
       read(ksday,'(I2)') isday
       write(*,*) "sday= ",isday
C
       call getenv("shour",kscy)
       read(kscy,'(I2)') iscy
       write(*,*) "shour= ",iscy
C
       call getenv("eyear",keyr)
       read(keyr,'(I4)') ieyr
       write(*,*) "eyear= ",ieyr

       call getenv("emonth",kemth)
       read(kemth,'(I2)') iemth
       write(*,*) "emonth= ",iemth
C
       call getenv("eday",keday)
       read(keday,'(I2)') ieday
       write(*,*) "eday= ",ieday
C
       call getenv("ehour",kecy)
       read(kecy,'(I2)') iecy
       write(*,*) "ehour= ",iecy
c
       call getenv("idim",kidim)
       read(kidim,'(I10)') idim
       write(*,*) "idim= ",idim
c
       call getenv("jdim",kjdim)
       read(kjdim,'(I10)') jdim
       write(*,*) "jdim= ",jdim
c
       call getenv("kpds5",kkpds5)
       read(kkpds5,'(I3)') kpds5
       write(*,*) "kpds5= ",kpds5
c
       call getenv("kpds6",kkpds6)
       read(kkpds6,'(I3)') kpds6
       write(*,*) "kpds6= ",kpds6
c
       call getenv("kpds7",kkpds7)
       read(kkpds7,'(I3)') kpds7
       write(*,*) "kpds7= ",kpds7
c
       call getenv("nfdys",knfdys)
       read(knfdys,'(I2)') nfdys
       write(*,*) "nfdys= ",nfdys
c
       if(igau.eq.1) then
         call splat(4,jdim,deg,wt)
         pi    = 4.0 * atan(1.0)
         pifac = 180.0 / pi
         do j=1,jdim
           deg(j) = pifac * asin(deg(j))
         enddo
       else
         dlat = 180.0 / float(jdim-1)
         do j=1,jdim
           deg(j)=90.-float(j-1)*dlat
         enddo
       endif
c
       call avg(idim,jdim,cfsrdir,clmcfsr,
     * cfsv2dir,clmcfsv2,expdir,clmexp,expname,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,kpds7,nfdys)
c
       stop
       end
       subroutine avg(idim,jdim,cfsrdir,clmcfsr,
     * cfsv2dir,clmcfsv2,expdir,clmexp,expname,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,kpds7,nfdys)
c
       CHARACTER*200 expname
       CHARACTER*200 cfsrdir,clmcfsr
       CHARACTER*200 cfsv2dir,clmcfsv2
       CHARACTER*200 expdir,clmexp
       CHARACTER*200 cfsrgrb,cfsrind,cfsrclm,cfsrclmind
       CHARACTER*200 cfsv2grb,cfsv2ind,cfsv2clm,cfsv2clmind
       CHARACTER*200 expgrb,expind,expclm,expclmind
       CHARACTER*200 clmdir,clmfile

       CHARACTER*4  LABY
       CHARACTER*2  LABM(12)
       CHARACTER*2  LABD(31)
       CHARACTER*2  LABC(0:23)

       real gridv(idim,jdim),climv(idim,jdim)
       real gridc(idim,jdim),climc(idim,jdim)
       real gridu(idim,jdim),climu(idim,jdim)
       real grid(idim,jdim)
       real anom(idim,jdim),anom1(idim,jdim)
       real deg(jdim),cosl(jdim)
c* 144 cases (twice a month for 6 years), 3 spheres, 140 6hr leads
      dimension rms(144,3,140),sx1(144,3,140),sy1(144,3,140),
     *cv(144,3,140)
      dimension crms(144,3,140),csx1(144,3,140),csy1(144,3,140),
     *ccv(144,3,140)
      real*4 save(idim,jdim,144,60:115)!60 to 115 is wk3-wk4 in 6hrlies
      real*4 savesec(idim,jdim,144,60:115)
      real*4 savever(idim,jdim,144,60:115)
      real*4 acts(144),cacts(144)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
c
       logical*1 lbms(idim,jdim)
c
       DATA LABC/'00','01','02','03','04','05',
     &           '06','07','08','09','10','11',
     &           '12','13','14','15','16','17',
     &           '18','19','20','21','22','23'/
C
       DATA LABD/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12','13','14','15','16','17','18','19','20',
     *           '21','22','23','24','25','26','27','28','29','30',
     *           '31'/
C
       DATA LABM/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12'/
C
      pi=4.*atan(1.)
      CONV=PI/180.
      DO j=1,181
         ALAT=90.-FLOAT(j-1)*1.
         cosl(j)=COS(ALAT*CONV)
      END DO
c
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)

       nfhrs=nfdys*24
       iyrc=2012
       icase=0
c... start cycle loop..
       do ncy=ncys,ncye,6

       nd=0
c... start initial condition loop..
       do ncn=ncns,ncne ! (Julian days range)
       nd=nd+1

       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

      if ((iday.eq.1).or.(iday.eq.15)) then

      icase=icase+1
c..  open cfsr climo file
       cfsrclm=clmcfsr(1:nfill(clmcfsr))//labm(imth)//'.'//labd(iday)//
     * '.00Z.mean.clim.daily.1x1.cfsr'
c      print *,cfsrclm
       call baopenr(11,cfsrclm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',cfsrclm
        stop
       endif
       cfsrclmind=cfsrclm(1:nfill(cfsrclm))//'.index'
c      print *,cfsrclmind
       call baopenr(12,cfsrclmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',cfsrclmind
        stop
       endif
c..  open cfsv2 climo file
       cfsv2clm=clmcfsv2(1:nfill(clmcfsv2))//labm(imth)//'.'//
     * labd(iday)//'.00Z.mean.clim.daily.cfsv2'
c      print *,cfsv2clm
       call baopenr(13,cfsv2clm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',cfsv2clm
        stop
       endif
       cfsv2clmind=cfsv2clm(1:nfill(cfsv2clm))//'.index'
c      print *,cfsv2clmind
       call baopenr(14,cfsv2clmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',cfsv2clmind
        stop
       endif
c..  open exp climo file
       expclm=clmexp(1:nfill(clmexp))//labm(imth)//'.'//labd(iday)//
     * '.00Z.mean.clim.daily.'//expname(1:nfill(expname))
c      print *,expclm
       call baopenr(15,expclm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',expclm
        stop
       endif
       expclmind=expclm(1:nfill(expclm))//'.index'
c      print *,expclmind
       call baopenr(16,expclmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',expclmind
        stop
       endif

c..  open cfsr data file
        cfsrgrb=cfsrdir(1:nfill(cfsrdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,cfsrgrb
        call baopenr(21,cfsrgrb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',cfsrgrb
         stop
        endif
        cfsrind=cfsrgrb(1:nfill(cfsrgrb))//'.index'
c       print *,cfsrind
        call baopenr(22,cfsrind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',cfsrind
         stop
        endif
c..  open cfsv2 data file
        cfsv2grb=cfsv2dir(1:nfill(cfsv2dir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,cfsv2grb
        call baopenr(23,cfsv2grb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',cfsv2grb
         stop
        endif
        cfsv2ind=cfsv2grb(1:nfill(cfsv2grb))//'.index'
c       print *,cfsv2ind
        call baopenr(24,cfsv2ind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',cfsv2ind
         stop
        endif
c..  open exp data file
        expgrb=expdir(1:nfill(expdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,expgrb
        call baopenr(25,expgrb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',expgrb
         stop
        endif
        expind=expgrb(1:nfill(expgrb))//'.index'
c       print *,expind
        call baopenr(26,expind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',expind
         stop
        endif

c... start forecast loop..
       do ifhr=6,nfhrs,6
        lead=ifhr/6

         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(5) = kpds5
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(9)  = imth
         JPDS(10) = iday
         JPDS(11) = icy
         JPDS(14) = ifhr
         JPDS(21) = ((iyr-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo

c...  first get climos
          JPDS(8) = mod(iyrc-1,100) + 1
          N=-1
          CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMV,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' cfsrclm = ',cfsrclm
           stop
          endif
          N=-1
          CALL GETGB(13,14,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMC,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' cfsv2clm = ',cfsv2clm
           stop
          endif
          N=-1
          CALL GETGB(15,16,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMU,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' expclm = ',expclm
           stop
          endif

c...  next, get data...
          JPDS(8) = mod(iyr-1,100) + 1
          N=-1
          CALL GETGB(21,22,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDV,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' cfsrgrb = ',cfsrgrb
           stop
          endif
          N=-1
          CALL GETGB(23,24,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDC,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' cfsv2grb = ',cfsv2grb
           stop
          endif
          N=-1
          CALL GETGB(25,26,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDU,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' expgrb = ',expgrb
           stop
          endif
c
         if(idbug.eq.1) then
          CALL GRIDAV(CLIMV,IDIM,JDIM,DEG,GCLIMV)
          CALL GRIDAV(CLIMC,IDIM,JDIM,DEG,GCLIMC)
          CALL GRIDAV(CLIMU,IDIM,JDIM,DEG,GCLIMU)
          CALL GRIDAV(GRIDV,IDIM,JDIM,DEG,GGRIDV)
          CALL GRIDAV(GRIDC,IDIM,JDIM,DEG,GGRIDC)
          CALL GRIDAV(GRIDU,IDIM,JDIM,DEG,GGRIDU)
          print 111,iyr,imth,iday,icase,lead,gclimv,gclimc,gclimu,
     *    ggridv,ggridc,ggridu
c* clim is climatologies, grid are frcst or verification
c* v=verification,c=control(cfsv2),u=experiment(exp)
      anom1=gridv-climv
      anom=gridu-climv!exp raw
      anom=gridc-climv!control raw
       if (lead.ge.60.and.lead.le.115)save(:,:,icase,lead)=anom(:,:)
       if (lead.ge.60.and.lead.le.115)savever(:,:,icase,lead)=anom1(:,:)
c* 1,70=NH; 71,111=TR; 112,181=SH
      x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,1)
      rms(icase,1,lead)=r
      sx1(icase,1,lead)=sx
      sy1(icase,1,lead)=sy
      cv(icase,1,lead)=cov
      x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,71,111,cov,sx,sy,r,1)
      rms(icase,2,lead)=r
      sx1(icase,2,lead)=sx
      sy1(icase,2,lead)=sy
      cv(icase,2,lead)=cov
      x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,112,181,cov,sx,sy,r,1)
      rms(icase,3,lead)=r
      sx1(icase,3,lead)=sx
      sy1(icase,3,lead)=sy
      cv(icase,3,lead)=cov
      anom=gridu-climu!exp SEC
      anom=gridc-climc!control SEC
       if (lead.ge.60.and.lead.le.115)savesec(:,:,icase,lead)=anom(:,:)
      x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,1)
      crms(icase,1,lead)=r
      csx1(icase,1,lead)=sx
      csy1(icase,1,lead)=sy
      ccv(icase,1,lead)=cov
      x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,71,111,cov,sx,sy,r,1)
      crms(icase,2,lead)=r
      csx1(icase,2,lead)=sx
      csy1(icase,2,lead)=sy
      ccv(icase,2,lead)=cov
      x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,112,181,cov,sx,sy,r,1)
      crms(icase,3,lead)=r
      csx1(icase,3,lead)=sx
      csy1(icase,3,lead)=sy
      ccv(icase,3,lead)=cov
         endif
c  end forecast loop
       enddo
 602   format(2i5,2x,3f8.1)

        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrclm
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrclmind
         stop
        endif
        call baclose(13,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsv2clm
         stop
        endif
        call baclose(14,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsv2clmind
         stop
        endif
        call baclose(15,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expclm
         stop
        endif
        call baclose(16,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expclmind
         stop
        endif

        call baclose(21,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrgrb
         stop
        endif
        call baclose(22,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrind
         stop
        endif
        call baclose(23,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsv2grb
         stop
        endif
        call baclose(24,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsv2ind
         stop
        endif
        call baclose(25,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expgrb
         stop
        endif
        call baclose(26,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expind
         stop
        endif
       endif

c  end initial condition loop
       enddo
c
c  end cycle loop
       enddo
c
      do ihemi=1,3!NH,TR,SH
       do lead=4,140,4
      call talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5)
      call talley(crms,csx1,csy1,ccv,lead,ihemi
     *,cres1,cres2,cres3,cres4,cres5)
      print 112,res1,res2,res3,res5,float(lead)/4.,
     *cres1,cres2,cres3,cres5,ihemi
       enddo
      print 112
      enddo 
      do ihemi=1,3!NH,TR,SH
       do lead=1,140
      call talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5)
      call talley(crms,csx1,csy1,ccv,lead,ihemi
     *,cres1,cres2,cres3,cres4,cres5)
      print 112,res1,res2,res3,res5,float(lead)/4.,
     *cres1,cres2,cres3,cres5,ihemi
       enddo
      print 112
      enddo
c* wk3
      write(6,729)
729   format(1h ,'wk3 ')
      do icase=1,144
       anom=0.
       anom1=0.
        do idum=0,27
        lead=60+idum
        grid(:,:)=save(:,:,icase,lead)
        anom=anom+grid/28.
        grid(:,:)=savever(:,:,icase,lead)
        anom1=anom1+grid/28.
        enddo
       x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,0)
       rms(icase,1,3)=r
       sx1(icase,1,3)=sx
       sy1(icase,1,3)=sy
       cv(icase,1,3)=cov
       anom=0.
        do idum=0,27
        lead=60+idum
        grid(:,:)=savesec(:,:,icase,lead)
        anom=anom+grid/28.
        enddo
       x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,0)
       crms(icase,1,3)=r
       csx1(icase,1,3)=sx
       csy1(icase,1,3)=sy
       ccv(icase,1,3)=cov
      enddo
c* wk4
      write(6,730)
730   format(1h ,'wk4 ')
      do icase=1,144
       anom=0.
       anom1=0.
        do idum=28,55
        lead=60+idum
        grid(:,:)=save(:,:,icase,lead)
        anom=anom+grid/28.
        grid(:,:)=savever(:,:,icase,lead)
        anom1=anom1+grid/28.
        enddo
       x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,0)
       rms(icase,1,4)=r
       sx1(icase,1,4)=sx
       sy1(icase,1,4)=sy
       cv(icase,1,4)=cov
       anom=0.
        do idum=28,55
        lead=60+idum
        grid(:,:)=savesec(:,:,icase,lead)
        anom=anom+grid/28.
        enddo
       x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,0)
       crms(icase,1,4)=r
       csx1(icase,1,4)=sx
       csy1(icase,1,4)=sy
       ccv(icase,1,4)=cov
      enddo
      write(6,731)
731   format(1h ,'wk3&4 ')
      do icase=1,144
       anom=0.
       anom1=0.
        do idum=0,55
        lead=60+idum
        grid(:,:)=save(:,:,icase,lead)
        anom=anom+grid/56.
        grid(:,:)=savever(:,:,icase,lead)
        anom1=anom1+grid/56.
        enddo
       x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,0)
       rms(icase,1,5)=r
       sx1(icase,1,5)=sx
       sy1(icase,1,5)=sy
       cv(icase,1,5)=cov
      acts(icase)=x*100.
       anom=0.
        do idum=0,55
        lead=60+idum
        grid(:,:)=savesec(:,:,icase,lead)
        anom=anom+grid/56.
        enddo
       x=ac(anom,anom1,cosl,idim,jdim,1.,1,idim,1,70,cov,sx,sy,r,0)
       crms(icase,1,5)=r
       csx1(icase,1,5)=sx
       csy1(icase,1,5)=sy
       ccv(icase,1,5)=cov
      cacts(icase)=x*100.
      enddo
      do ihemi=1,1!NH
       do lead=3,5
      call talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5)
      call talley(crms,csx1,csy1,ccv,lead,ihemi
     *,cres1,cres2,cres3,cres4,cres5)
      print 112,res1,res2,res3,res5,float(lead),
     *cres1,cres2,cres3,cres5,ihemi
       enddo
      enddo
      write(6,732)
      write(6,732)(acts(icase),icase=1,144)
      write(6,732)
      write(6,732)(cacts(icase),icase=1,144)
732   format(24f5.1)
      do in=1,24
      ave=0.
      cave=0.
      do idum=in,140,24
      ave=ave+acts(idum)
      cave=cave+cacts(idum)
      enddo
      acts(in)=ave/6.
      cacts(in)=cave/6.
      enddo
      write(6,732)
      write(6,732)(acts(in),in=1,24)
      write(6,732)
      write(6,732)(cacts(in),in=1,24)
      write(6,732)
      write(6,732)(cacts(in)-acts(in),in=1,24)
      call loccor(save,savever,idim,jdim,17)
      call loccor(savesec,savever,idim,jdim,18)
 111   format(5i5,2x,6f10.2)
 112   format(4f7.1,f7.2,4f7.1,i4)
         return
         end
c
      function ac(anom,anom1,cosl,im,jm,fak,
     *ib,ie,lb,le,cov,sx,sy,r,ip)
      dimension anom(im,jm),cosl(jm)
      dimension anom1(im,jm)
      x=0.
      y=0.
      avx=0.
      avy=0.
      z=0.
      r=0.
      zz=0.
      do jlat=lb,le
      w=cosl(jlat)
      do i=ib,ie
      ax=anom(i,jlat)/fak
      ay=anom1(i,jlat)/fak
      avx=avx+ax*w
      avy=avy+ay*w
      x=x+(ax*ax)*w
      y=y+(ay*ay)*w
      z=z+(ay*ax)*w
      r=r+(ay-ax)*(ay-ax)*w
      zz=zz+w
      enddo
      enddo
      sx=0.00000001
      sy=0.00000001
      if (x.gt.0.) sx=sqrt(x/zz)
      if (y.gt.0.) sy=sqrt(y/zz)
      if (r.gt.0.) r=sqrt(r/zz)
      ac=z/zz/sx/sy
      cov=z/zz
      avx=avx/zz
      avy=avy/zz
      if (ip.eq.1)write(6,101)avx,avy,sx,sy,ac*100.,lb,le,r,zz
101   format(1h ,'inside ac:',5f10.1,2i4,2f10.1)
      return
      end
c
      subroutine talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5)
      dimension rms(144,3,140),sx1(144,3,140),sy1(144,3,140),
     *cv(144,3,140)
       av1=0.
       av2=0.
       av3=0.
       av4=0.
       n=0
       do icase=1,144
       r=rms(icase,ihemi,lead)
       sx=sx1(icase,ihemi,lead)
       sy=sy1(icase,ihemi,lead)
       c=cv(icase,ihemi,lead)
       av1=av1+r*r
       av2=av2+sx*sx
       av3=av3+sy*sy
       av4=av4+c
       n=n+1
       enddo
       res1=sqrt(av1/float(n))
       res2=sqrt(av2/float(n))
       res3=sqrt(av3/float(n))
       res4=av4/float(n)
       res5=res4/(res2*res3)*100.
      return
      end
c
      subroutine loccor(save,savever,idim,jdim,idch)
      real*4 save(idim,jdim,144,60:115)!60 to 115 is wk3-wk4 in 6hrlies
      real*4 savever(idim,jdim,144,60:115)
      real*4 rms(idim,jdim),sx(idim,jdim),sy(idim,jdim),cov(idim,jdim)
      real*4 r(idim,jdim),x(idim,jdim),y(idim,jdim),acloc(idim,jdim)
      rms=0. 
      sx=0. 
      sy=0. 
      cov=0. 
      fak=56.*140.
      do icase=1,140
      do lead=60,115
      x(:,:)=save(:,:,icase,lead)
      y(:,:)=savever(:,:,icase,lead)
      r=x-y
      rms=rms+r*r/fak
      sx=sx+x*x/fak
      sy=sy+y*y/fak
      cov=cov+x*y/fak
      enddo
      enddo
      sx=sqrt(sx)
      sy=sqrt(sy)
      acloc=100.*cov/(sx*sy)
      write(idch)acloc
c     write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
100   format(1h ,'loc ac:',5f10.1)
      return
      end
