c******************************************************
c.... use fcmpsp to compile....
c******************************************************
       character*300 ingrib,indfile
       character*10 kidim,kjdim,kgau
c
       dimension grid(2000,1000)
       dimension deg(2000)
       dimension wt(2000)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
       logical*1 lbms(2000,1000)
c
       call GETENV("ingrib",ingrib)
       write(*,*) "ingrib= ",ingrib
c
       call GETENV("igau",kgau)
       read(kgau,'(i1)') igau
       write(*,*) "igau= ",igau
C
       call GETENV("idim",kidim)
       read(kidim,'(I10)') idim
       write(*,*) "idim= ",idim
c
       call GETENV("jdim",kjdim)
       read(kjdim,'(I10)') jdim
       write(*,*) "jdim= ",jdim
c
       if(igau.eq.1) then
       call splat(4,jdim,deg,wt)
       else
       do j=1,jdim
       deg(j)=90.-float(j-1)*2.5
       enddo
       endif
c      do j=1,jdim
c      print *,j,deg(j)
c      enddo
c 
       call baopenr(11,ingrib,ierr)
       if(ierr.ne.0) then
       print *,'error opening file ',ingrib
       call abort
       endif
c
       nr=0
       N=-2
 100   continue
c
       do k=1,200
       JPDS(k)=-1
       enddo
       do k=1,200
       JGDS(k)=-1
       enddo
       N=N+1
       CALL GETGB(11,0,idim*jdim,N,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,GRID,IRET)
       if(iret.ne.0) then
       print *,'rec ',n+1,' error in GETGB for rc = ',iret
       stop
       endif
c
c      do j=1,jdim
c      print *,j,(grid(i,j),i=1,10)
c      enddo
c      stop
c
       print *,N,(kpds(i),i=1,25)
c      print *,N+2,(kpds(i),i=5,7),kpds(22)
c      print *,(kgds(i),i=1,22)
c
       go to 100
c
       call baclose(11,ierr)
c
       stop
       end
